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
#  user_id              :bigint           not null
#
# Indexes
#
#  index_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#


require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
