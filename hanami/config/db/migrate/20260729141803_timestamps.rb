# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://hanakai.org/learn/hanami/database/migrations/ for details.
  change do
    alter_table :podcasts do
      set_column_default :created_at, Sequel::CURRENT_TIMESTAMP
      set_column_default :updated_at, Sequel::CURRENT_TIMESTAMP
    end

    alter_table :profiles do
      set_column_default :created_at, Sequel::CURRENT_TIMESTAMP
      set_column_default :updated_at, Sequel::CURRENT_TIMESTAMP
    end
    alter_table :episodes do
      set_column_default :created_at, Sequel::CURRENT_TIMESTAMP
      set_column_default :updated_at, Sequel::CURRENT_TIMESTAMP
    end
    alter_table :podcast_hosts do
      set_column_default :created_at, Sequel::CURRENT_TIMESTAMP
      set_column_default :updated_at, Sequel::CURRENT_TIMESTAMP
    end
  end
end
