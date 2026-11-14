begin
  require "hanami/cli"
  require "hanami/cli/commands/app/db/utils/database"
rescue LoadError
end

module Cast
  module MigrationsPatch
    OPTIONS = { table: :cast_schema_migrations }.freeze

    def run_migrations(**) = super(**OPTIONS, **)

    def sequel_migrator
      @sequel_migrator ||= begin
         require "sequel"
         require "rom/sql"

         slice.prepare :db

         Sequel.extension :migration

         ROM::SQL.with_gateway(gateway) do
           Sequel::TimestampMigrator.new(migrator.connection, migrations_path, OPTIONS)
         end
      end
    end

    def schema_migrations_sql_dump
      return unless migrations_dir?
      rows = applied_migrations.map { |v| "('#{v}')" }.join(",\n")
      "INSERT INTO #{OPTIONS[:table]} (filename) VALUES\n#{rows};"
    end
  end
end

if defined?(Hanami::CLI::Commands::App::DB::Utils::Database)
  Hanami::CLI::Commands::App::DB::Utils::Database.prepend Cast::MigrationsPatch
end
