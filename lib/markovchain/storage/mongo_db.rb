class Markovchain
  module Storage
    class MongoDb
      def initialize(options = {})
        @collection = options[:mongo][options[:db]][options[:collection]]
      end

      def tokens_after(sequence)
        records = @collection.find({'sequence' => sequence})
        if records and records.count > 0
          Hash[*records.map{|r| [r['token'], r['count']] }.flatten]
        else
          {}
        end
      end

      def increment(prev_sequence, token)
        @collection.update(
          {"sequence" => prev_sequence, "token" => token},
          {"$inc" => {"count" => 1}},
          {:upsert => true}
        )
      end
    end
  end
end
