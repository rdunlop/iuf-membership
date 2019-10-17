# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberFinder, type: :model do
  let!(:member) do
    create(:member,
           first_name: 'Bob',
           last_name: 'Smith',
           alternate_first_name: 'Robert',
           alternate_last_name: 'Smith-Jones',
           birthdate: Date.new(2000, 1, 2))
  end

  context 'with a payment for the member' do
    let!(:payment) { create(:payment, member: member) }

    context 'when the name matches exactly' do
      let(:first_name) { 'Bob' }
      let(:last_name) { 'Smith' }

      it 'can find the member' do
        expect(described_class.find_paid(first_name: first_name, last_name: last_name, birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'when the name is passed with extra space' do
      let(:first_name) { ' Bob ' }
      let(:last_name) { '  Smith  ' }

      it 'can find the member' do
        expect(described_class.find_paid(first_name: first_name, last_name: last_name, birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'When the name is different case' do
      let(:first_name) { 'bob' }
      let(:last_name) { 'smith' }

      it 'can find the member' do
        expect(described_class.find_paid(first_name: first_name, last_name: last_name, birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'when the name has accents' do
      let!(:member) do
        create(:member,
               first_name: 'Olaf',
               last_name: 'Svgürst',
               birthdate: Date.new(2000, 0o1, 0o2))
      end

      it 'can find with the accents' do
        expect(described_class.find_paid(first_name: 'Olaf', last_name: 'Svgürst', birthdate: '2000-01-02')).to eq(member)
      end

      it 'Can find without the accents' do
        expect(described_class.find_paid(first_name: 'Olaf', last_name: 'Svgurst', birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'when searching by alternate first name' do
      it 'finds the same record' do
        expect(described_class.find_paid(first_name: 'Robert', last_name: 'Smith', birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'when searching by alternate last name' do
      it 'finds the same record' do
        expect(described_class.find_paid(first_name: 'Bob', last_name: 'Smith-Jones', birthdate: '2000-01-02')).to eq(member)
      end
    end

    context 'when searching by alternate names' do
      it 'finds the same record' do
        expect(described_class.find_paid(first_name: 'Robert', last_name: 'Smith-Jones', birthdate: '2000-01-02')).to eq(member)
      end
    end
  end

  context 'when there are multiple members with the same info' do
    let!(:member2) do
      create(:member,
             first_name: 'Bob',
             last_name: 'Smith',
             birthdate: Date.new(2000, 1, 2))
    end

    context 'when the second member is the paid member' do
      let!(:payment) { create(:payment, member: member2) }

      it 'returns the _paid_ member first' do
        expect(described_class.find_paid(first_name: 'Bob', last_name: 'Smith', birthdate: '2000-01-02')).to eq(member2)
      end
    end
  end
end
