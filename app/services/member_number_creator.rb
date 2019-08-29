# frozen_string_literal: true

# Manages the allocation of member numbers
class MemberNumberCreator
  def self.allocate_number
    existing_ids = Member.all.pluck(:iuf_id)

    range = (1..1_000_000)

    range.each do |number|
      next if existing_ids.include?(number)

      return number
    end
  end
end
