class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  if Rails.env.test?
    connects_to database: {writing: :sqlite, reading: :sqlite}
  end

  before_create -> { self.id ||= SecureRandom.uuid }
end
