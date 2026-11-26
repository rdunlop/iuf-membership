#!/bin/bash
# Loads secrets from a .env-style file into SSM Parameter Store under /iuf-membership/{environment}/
# The ECS task definition (terraform/main.tf, secret_names) reads these names at container start.
#
# Usage:
#   script/load_ssm_params.sh staging path/to/outside-the-repo/iuf-staging.env
#   script/load_ssm_params.sh prod    path/to/outside-the-repo/iuf-prod.env
#
# Only the names in REQUIRED_KEYS are written. Any other key in the file is reported and ignored.
# The script fails before writing anything if a required key is missing or empty.
# All values are stored as SecureString (KMS-encrypted). Re-running overwrites existing parameters.
#
# Keep the env file OUTSIDE the repo. It contains secrets and must never be committed.
#
# Works with the bash 3.2 that ships with macOS.
# REQUIRED_KEYS must match secret_names in terraform/main.tf.

set -euo pipefail

ENVIRONMENT=${1:?"Usage: $0 <staging|prod> <path/to/.env>"}
ENV_FILE=${2:?"Usage: $0 <staging|prod> <path/to/.env>"}
REGION="eu-central-1"
PREFIX="/iuf-membership/${ENVIRONMENT}"

REQUIRED_KEYS=(
  SECRET_KEY_BASE
  DATABASE_HOST DATABASE_NAME DATABASE_USERNAME DATABASE_PASSWORD
  PAYPAL_CLIENT_ID PAYPAL_SECRET
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  EMAIL_FROM
  ROLLBAR_ACCESS_TOKEN ROLLBAR_CLIENT_ACCESS_TOKEN
)

# Staging keeps the HTTP basic auth gate. Prod does not, so these are required for staging only.
if [[ "$ENVIRONMENT" == "staging" ]]; then
  REQUIRED_KEYS+=(BASIC_AUTH_USERNAME BASIC_AUTH_PASSWORD)
fi

case "$ENVIRONMENT" in
  staging|prod) ;;
  *) echo "Error: environment must be staging or prod" >&2; exit 1 ;;
esac

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found" >&2
  exit 1
fi

# Prints the value of KEY from ENV_FILE (last occurrence wins). Strips surrounding quotes.
# Prints nothing if the key is absent.
get_value() {
  local key="$1" line value
  line=$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 || true)
  [[ -z "$line" ]] && return 0
  value="${line#*=}"
  if [[ "$value" =~ ^\'(.*)\'$ ]]; then
    value="${BASH_REMATCH[1]}"
  elif [[ "$value" =~ ^\"(.*)\"$ ]]; then
    value="${BASH_REMATCH[1]}"
  fi
  printf '%s' "$value"
}

# Check every required key is present and non-empty before writing anything.
MISSING=()
for KEY in "${REQUIRED_KEYS[@]}"; do
  if [[ -z "$(get_value "$KEY")" ]]; then
    MISSING+=("$KEY")
  fi
done
if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Error: missing or empty in $ENV_FILE:" >&2
  for KEY in "${MISSING[@]}"; do echo "  $KEY" >&2; done
  echo "Nothing was written." >&2
  exit 1
fi

# Report keys in the file that are not loaded.
while IFS= read -r KEY; do
  [[ -z "$KEY" ]] && continue
  if ! printf '%s\n' "${REQUIRED_KEYS[@]}" | grep -qx "$KEY"; then
    echo "Ignoring (not a secret_names entry): $KEY"
  fi
done < <(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$ENV_FILE" | cut -d= -f1 | sort -u)

echo "Loading $ENV_FILE → SSM ${PREFIX}/ (region ${REGION})"
echo ""

# Write each value from a temp file, so the secret never appears in the process list.
TMP_VALUE=$(mktemp)
chmod 600 "$TMP_VALUE"
trap 'rm -f "$TMP_VALUE"' EXIT

for KEY in "${REQUIRED_KEYS[@]}"; do
  echo "  ${PREFIX}/${KEY}"
  get_value "$KEY" > "$TMP_VALUE"
  aws ssm put-parameter \
    --region "$REGION" \
    --name "${PREFIX}/${KEY}" \
    --value "file://${TMP_VALUE}" \
    --type SecureString \
    --overwrite \
    --no-cli-pager \
    > /dev/null
done

echo ""
echo "Done. Verify with:"
echo "  aws ssm get-parameters-by-path --path ${PREFIX}/ --region ${REGION} --query 'Parameters[*].Name'"
