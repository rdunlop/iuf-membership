terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "eu-central-1"
}

# ---- ECR ----

resource "aws_ecr_repository" "app" {
  name                 = "iuf-membership"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 10
        description  = "Keep last 5 prod deployments (rollback buffer)"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["prod-"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 20
        description  = "Keep last 10 images (current staging + recent undeployed builds)"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = { type = "expire" }
      },
    ]
  })
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

# ---- CI IAM user (CircleCI) ----

resource "aws_iam_user" "circleci" {
  name = "circleci-iuf-membership"
}

resource "aws_iam_access_key" "circleci" {
  user = aws_iam_user.circleci.name
}

resource "aws_iam_policy" "circleci" {
  name = "circleci-iuf-membership"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
        ]
        Resource = aws_ecr_repository.app.arn
      },
      {
        # One-off db:migrate and release commands run as ECS tasks from CI.
        Sid    = "ECSTaskDefs"
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
        ]
        Resource = "*"
      },
      {
        Sid    = "ECSRunTask"
        Effect = "Allow"
        Action = "ecs:RunTask"
        Resource = [
          "arn:aws:ecs:eu-central-1:*:task-definition/iuf-membership-*:*",
          "arn:aws:ecs:eu-central-1:*:cluster/iuf-membership-*",
        ]
      },
      {
        Sid    = "ECSInspect"
        Effect = "Allow"
        Action = [
          "ecs:DescribeTasks",
          "ecs:DescribeServices",
          "ecs:WaitUntilTasksStopped",
        ]
        Resource = "*"
      },
      {
        Sid      = "ECSUpdateService"
        Effect   = "Allow"
        Action   = "ecs:UpdateService"
        Resource = "arn:aws:ecs:eu-central-1:*:service/iuf-membership-*/*"
      },
      {
        Sid      = "PassECSRoles"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::*:role/iuf-membership-*-ecs-*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "circleci" {
  user       = aws_iam_user.circleci.name
  policy_arn = aws_iam_policy.circleci.arn
}

output "circleci_access_key_id" {
  value = aws_iam_access_key.circleci.id
}

output "circleci_secret_access_key" {
  value     = aws_iam_access_key.circleci.secret
  sensitive = true
}
