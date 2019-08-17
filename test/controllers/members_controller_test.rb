# frozen_string_literal: true

require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in(users(:one))
  end

  test 'should get index' do
    get members_url
    assert_response :success
  end

  test 'should get new' do
    get new_member_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_member_url(members(:one))
    assert_response :success
  end
end
