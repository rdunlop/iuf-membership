# frozen_string_literal: true

# Search for a member given 3 parameters.
# Deals with figuring out how to match the given
# parameters with the existing data, ignoring unimportant
# variations
class MemberFinder
  def self.find_by(first_name:, last_name:, birthdate:)
    bday = Date.parse(birthdate)

    Member.where(
      Member.arel_table[:first_name].matches(first_name),
      Member.arel_table[:last_name].matches(last_name)
    ).where(birthdate: bday).first
  end
end
