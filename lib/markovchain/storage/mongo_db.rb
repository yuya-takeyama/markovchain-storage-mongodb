class Markovchain
  module Storage
    class MongoDb
      def initialize(options = {})
        @collection = options[:mongo][options[:db]][options[:collection]]
      end

      def tokens_after(sequence)
        record = @collection.find_one({'sequence' => sequence})
        if record and record['tokens']
          record['tokens']
        else
          {}
        end
      end

      def increment(prev_sequence, token)
        @collection.update(
          {"sequence" => prev_sequence},
          {"$inc" => {"tokens.#{token}" => 1}},
          {:upsert => true}
        )
      end
    end
  end
end
