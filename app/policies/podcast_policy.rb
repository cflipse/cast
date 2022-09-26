class PodcastPolicy < ApplicationPolicy
  alias_method :podcast, :record

  def update?
    admin? ||
      roles.include?(podcast.slug)
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
