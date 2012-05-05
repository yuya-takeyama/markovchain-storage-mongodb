require 'markovchain-storage-mongodb'
require 'mongo'

module Markovchain::Storage
  describe MongoDb do
    let(:mongo) { ::Mongo::Connection.new }
    let(:db) { 'markovchain_storage_mongodb_test' }
    let(:collection) { 'markovchain_storage_mongodb_test_storage' }

    before do
      mongo[db].drop_collection(collection)
      mongo[db].create_collection(collection)
    end

    let(:storage) do
      ::Markovchain::Storage::MongoDb.new(
        :mongo      => mongo,
        :db         => db,
        :collection => collection,
      )
    end

    describe '#tokens_after' do
      subject { storage.tokens_after(sequence) }
      let(:sequence) { 'foo' }

      context 'when no records matched' do
        it { should == {} }
      end

      context 'when a record matched' do
        before { storage.increment(sequence, token) }
        let(:token) { 'b' }
        it { should == {'b' => 1} }
      end

      context 'when many token seeded' do
        before do
          storage.increment(sequence, 'a')
          storage.increment(sequence, 'a')
          storage.increment(sequence, 'a')
          storage.increment(sequence, 'b')
          storage.increment(sequence, 'b')
          storage.increment(sequence, 'c')
        end
        it { should == {'a' => 3, 'b' => 2, 'c' => 1} }
      end
    end
  end
end
