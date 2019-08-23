# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member Creation', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  xit 'can create a member' do
    visit '/members'
    fill_in :first_name, with: 'Bob'
    fill_in :last_name, with: 'Smith'
    click_button 'Create Member'

    expect(page).to have_text('Created')
  end
end
