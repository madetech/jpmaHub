require 'sequel'

module DatabaseAdministrator
  class Postgres
    def initialize
      @migrator = Migrator.new
    end

    def fresh_database
      database = existing_database

      @migrator.destroy(database)
      @migrator.migrate(database)

      database
    end

    def existing_database
      database = Sequel.connect(ENV['DATABASE_URL'])

      @migrator.migrate(database)
      database
    end
  end
end