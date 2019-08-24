# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  it 'can log in' do
    visit '/'
    click_on 'Manage my Memberships'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text('Members')
  end
end
