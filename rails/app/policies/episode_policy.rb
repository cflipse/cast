class EpisodePolicy < ApplicationPolicy
  alias_method :episode, :record

  def update?
    admin? || roles.include?(podcast_slug)
  end

  def create?
    admin? || roles.include?(podcast_slug)
  end

  def destroy?
    admin? || roles.include?(podcast_slug)
  end

  private

  def podcast
    record.respond_to?(:podcast) ? record.podcast : record
  end

  delegate :slug, to: :podcast, prefix: true, allow_nil: true

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
