# frozen_string_literal: true

class MemberPolicy < ApplicationPolicy
  def index?
    user
  end

  def create?
    user
  end

  def show?
    record.user == user
  end

  def update?
    record.user == user && record.payments.none?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
