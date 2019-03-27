# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher.rb'
require_relative '../sk_cipher'
require 'minitest/autorun'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
  end

  cipher_methods = ['Caesar', 'Permutation', 'Double Transposition',
                    'Modern Symmetric']
  cipher_modules = []
  cipher_modules << SubstitutionCipher::Caesar
  cipher_modules << SubstitutionCipher::Permutation
  cipher_modules << DoubleTranspositionCipher
  cipher_modules << ModernSymmetricCipher

  cipher_methods.each_with_index do |method, idx|
    describe "Using #{method} cipher" do
      it 'should encrypt card information' do
        key = cipher_modules[idx].generate_new_key
        enc = cipher_modules[idx].encrypt(@cc.to_s, key)
        enc.wont_equal @cc.to_s
        enc.wont_be_nil
      end

      it 'should decrypt text' do
        key = cipher_modules[idx].generate_new_key
        enc = cipher_modules[idx].encrypt(@cc.to_s, key)
        dec = cipher_modules[idx].decrypt(enc, key)
        dec.must_equal @cc.to_s
      end
    end
  end
end
