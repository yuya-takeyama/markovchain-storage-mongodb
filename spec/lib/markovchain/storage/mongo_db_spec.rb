require 'markovchain'
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

      context 'sequence contains . (dot) specified' do
        let(:sequence) { 'f.o' }
        before do
          storage.increment(sequence, 'a')
        end
        it { should == {'a' => 1} }
      end

      context 'token is a . (dot)' do
        let(:token) { '.' }
        before do
          storage.increment(sequence, token)
        end
        it { should == {token => 1} }
      end
    end

    context 'integrated with Markovchain' do
      let(:mc) { Markovchain.new(:storage => storage, :state_size => 2) }
      before { 100.times { mc.seed('abcdefg') } }
      subject { mc.random_sequence }
      it { should == 'abcdefg' }
    end
  end
end
