# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member Update', type: :system do
  include Devise::Test::IntegrationHelpers
  let!(:user) { FactoryBot.create(:user) }
  let!(:member) { FactoryBot.create(:member, user: user) }

  before do
    sign_in(user)
  end

  it 'can edit the member' do
    visit edit_member_path(member)
    fill_in 'First name', with: 'Jane'
    fill_in 'Last name', with: 'Smith'
    click_button 'Update Member'

    expect(page).to have_text('Member updated')
  end
end
