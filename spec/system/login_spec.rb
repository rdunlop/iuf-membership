# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  xit 'can log in' do
    visit '/'
    fill_in :email, with: user.email
    fill_in :password, with: 'password'
    click_button 'Sign In'

    expect(page).to have_tex('Members')
  end
end
