class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to database: {writing: :sqlite, reading: :sqlite}

  before_create -> { self.id ||= SecureRandom.uuid }
end
