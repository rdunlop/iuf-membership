# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:member) { create(:member, user: user) }

  subject { described_class }

  shared_examples_for 'logged in users only' do
    it 'allows logged in user' do
      expect(subject).to permit(user, Member)
    end

    it 'disallows logged-out user' do
      expect(subject).not_to permit(nil, Member)
    end
  end

  permissions :index? do
    it_behaves_like 'logged in users only'
  end

  permissions :new? do
    it_behaves_like 'logged in users only'
  end

  permissions :show? do
    it 'allows same user to view' do
      expect(subject).to permit(user, member)
    end

    it 'disallows other user to view' do
      expect(subject).not_to permit(create(:user), member)
    end
  end

  shared_examples_for 'disallow with payment' do
    context 'without a payment' do
      it 'allows updates' do
        expect(subject).to permit(user, member)
      end
    end

    context 'with payment' do
      let!(:payment) { create(:payment, member: member) }
      it 'does not allow updates' do
        expect(subject).not_to permit(user, member)
      end
    end
  end

  permissions :update? do
    it_behaves_like 'disallow with payment'
  end

  permissions :destroy? do
    it_behaves_like 'disallow with payment'
  end
end
