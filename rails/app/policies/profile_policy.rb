class ProfilePolicy < ApplicationPolicy
  alias_method :profile, :record

  def index?
    true
  end

  def show?
    true
  end

  def update?
    admin? || user == profile
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
