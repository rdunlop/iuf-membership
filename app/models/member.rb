# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :user

  def to_s
    [first_name, last_name].join(' ')
  end
end
