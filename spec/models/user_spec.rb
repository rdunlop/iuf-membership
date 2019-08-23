# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'can be created' do
    user = User.new(email: 'test@example.com', password: 'password')
    expect(user).to be_valid
  end
end
