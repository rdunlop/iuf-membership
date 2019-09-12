# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  let(:email) { 'fake@example.com' }
  it 'can sign up' do
    visit '/'
    click_on 'My Memberships'

    # Now on the Log-in Page
    click_on 'Sign up'

    # Now on Sign-up page
    fill_in 'Email', with: email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    check 'user_agree_to_privacy_policy'
    click_button 'Sign up'

    expect(page).to have_text('A message with a confirmation link has been sent to your email address')
  end
end
