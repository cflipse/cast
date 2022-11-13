# frozen_string_literal: true

class EpisodeAdminComponent < ApplicationComponent
  extend Dry::Initializer

  param :podcast
  param :episode

  option :policy

  delegate :edit?, :destroy?, to: :policy

  def render?
    edit? || destroy?
  end

  def delete_classes
    rounding = edit? ? "rounded-r-md" : "rounded-md"
    "bg-red-700 text-gray-300 p-2 #{rounding}"
  end

  def delete_form_attributes
    {
      class: "inline-block",
      data: {"turbo-confirm": "Are you sure you want to remove this episode?"}
    }
  end

  def edit_classes
    rounding = destroy? ? "rounded-l-md" : "rounded-md"
    "bg-amber-700 text-gray-300 p-2 #{rounding}"
  end
end
