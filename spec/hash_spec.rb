# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

hash_methods = {
  'regular' => :hash,
  'cryptographic' => :hash_secure
}

describe 'Test hashing requirements' do
  hash_methods.each do |name, symbol|
    describe "Test #{name} hashing" do
      describe 'Check hashes are consistently produced' do
        # Check that each card produces the same hash if hashed repeatedly
        cards.each do |card|
          it 'should produce identical hashes' do
            hash1 = card.send(symbol)
            hash2 = card.send(symbol)
            _(hash2).must_equal hash1
          end
        end
      end

      describe 'Check for unique hashes' do
        # Check that each card produces a different hash than other cards
        hashes = cards.map(&symbol)
        hashes.each_with_index do |hash, index|
          it 'should produce unique hashes' do
            other_hashes = Array.new(hashes)
            other_hashes.delete_at(index)
            _(other_hashes).wont_include hash
          end
        end
      end
    end
  end

  describe 'Check regular hash not same as cryptographic hash' do
    # Check that each card's hash is different from its hash_secure
    hashes = cards.map(&:hash)
    secure_hashes = cards.map(&:hash_secure)
    hashes.zip(secure_hashes).each do |hash, secure_hash|
      it 'should produce different hash_secure from hash' do
        _(secure_hash).wont_equal hash
      end
    end
  end
end
