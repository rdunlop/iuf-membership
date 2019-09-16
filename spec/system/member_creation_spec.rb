# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member Creation', type: :system do
  include Devise::Test::IntegrationHelpers
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  it 'can create a member' do
    visit '/members'
    fill_in 'First name', with: 'Bob'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Birthdate', with: '12/12/1999'
    click_button 'Create Member'

    expect(page).to have_text('Member created')
  end
end
