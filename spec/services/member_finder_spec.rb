# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberFinder, type: :model do
  let!(:member) { create(:member, first_name: 'Bob', last_name: 'Smith', birthdate: Date.new(2000, 0o1, 0o2)) }

  it 'Can find when name matches exactly' do
    expect(described_class.find_by(first_name: 'Bob', last_name: 'Smith', birthdate: '2000-01-02')).to eq(member)
  end

  it 'can find when the name is different case' do
    expect(described_class.find_by(first_name: 'bob', last_name: 'smith', birthdate: '2000-01-02')).to eq(member)
  end

  context 'when the name has accents' do
    let!(:member) do
      create(:member,
             first_name: 'Olaf',
             last_name: 'Svgürst',
             birthdate: Date.new(2000, 0o1, 0o2))
    end

    it 'can find with the accents' do
      expect(described_class.find_by(first_name: 'Olaf', last_name: 'Svgürst', birthdate: '2000-01-02')).to eq(member)
    end

    it 'Can find without the accents' do
      expect(described_class.find_by(first_name: 'Olaf', last_name: 'Svgurst', birthdate: '2000-01-02')).to eq(member)
    end
  end
end
