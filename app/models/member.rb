# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                   :bigint           not null, primary key
#  alternate_first_name :string
#  alternate_last_name  :string
#  birthdate            :date
#  contact_email        :string
#  first_name           :string
#  last_name            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  iuf_id               :integer
#  user_id              :bigint           not null
#
# Indexes
#
#  index_members_on_iuf_id   (iuf_id) UNIQUE
#  index_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Member < ApplicationRecord
  belongs_to :user
  has_many :payments, dependent: :restrict_with_error

  validates :first_name, :last_name, :birthdate, presence: true
  validate :must_be_unique_if_paid_exists

  def to_s
    [first_name, last_name].join(' ')
  end

  def active?
    payments.any?
  end

  private

  def must_be_unique_if_paid_exists
    # return unless first_name.present?
    # return unless last_name.present?
    return if birthdate.blank?

    matching_members = MemberFinder.find_all(
      first_name: first_name,
      last_name: last_name,
      birthdate: birthdate.to_s
    ).reject { |member| member.id == id }

    errors.add(:base, 'A paid membership already exists for this name/birthday combination') if matching_members.any?(&:active?)
  end
end
