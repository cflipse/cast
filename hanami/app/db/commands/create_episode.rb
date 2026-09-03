module Cast
  module DB
    module Commands
      class CreateEpisode < ROM::Commands::Create[:sql]
        result :one
        relation :episodes
        register_as :create

        before :add_uuid

        def add_uuid(tuple)
          { uuid: SecureRandom.uuid }.merge(tuple)
        end
      end
    end
  end
end
