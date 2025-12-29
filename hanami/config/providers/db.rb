require "rom/core"

Hanami.app.configure_provider :db do
  config.gateway :default do |gw|
    gw.adapter :sql do |sql|
      sql.plugin schema: :timestamps
      sql.plugin command: :timestamps
    end
  end
end
