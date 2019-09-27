# frozen_string_literal: true

# Search for a member given 3 parameters.
# Deals with figuring out how to match the given
# parameters with the existing data, ignoring unimportant
# variations
class MemberFinder
  def self.find_by(first_name:, last_name:, birthdate:)
    find_all(
      first_name: first_name,
      last_name: last_name,
      birthdate: birthdate
    ).first
  end

  def self.find_all(first_name:, last_name:, birthdate:) # rubocop:disable Metrics/MethodLength
    bday = Date.parse(birthdate)

    Member.where(birthdate: bday).select do |possible_match|
      check_name(
        search_name: first_name&.strip,
        option_one: possible_match.first_name,
        option_two: possible_match.alternate_first_name
      ) &&
        check_name(
          search_name: last_name&.strip,
          option_one: possible_match.last_name,
          option_two: possible_match.alternate_last_name
        )
    end
  end

  # Use transliterate in order to ignore accents and other unexpected characters
  def self.check_name(search_name:, option_one:, option_two:)
    target_name = ActiveSupport::Inflector.transliterate(search_name).downcase

    return true if option_one.present? && ActiveSupport::Inflector.transliterate(option_one).downcase == target_name
    return true if option_two.present? && ActiveSupport::Inflector.transliterate(option_two).downcase == target_name

    false
  end
end
