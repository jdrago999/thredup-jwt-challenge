require 'spec_helper'

describe JWT::Token do
  describe '.initialize(secret:)' do
    context 'when the secret' do
      context 'is provided' do
        before do
          @secret = SecureRandom.uuid
          @token = described_class.new(secret: @secret)
        end
        it 'stores the secret' do
          expect(@token.secret).to eq(@secret)
        end
        it 'initializes its data as an empty Hash' do
          expect(@token.data).to be_a Hash
          expect(@token.data).to be_empty
        end
      end
      context 'is not provided' do
        it 'raises an ArgumentError' do
          expect{described_class.new}.to raise_error ArgumentError
        end
      end
    end
  end

  describe '#key_count' do
    before do
      @token = described_class.new(secret: 's3cr3t')
    end
    context 'when there is no data' do
      it 'returns 0' do
        expect(@token.key_count).to eq(0)
      end
    end
    context 'when there is data' do
      before do
        @keys_to_add = rand(100).to_i
        @keys_to_add.times do |time|
          @token.add_pair!(key: 'foo%04d' % time, value: time)
        end
      end
      it 'returns the number of keys added' do
        expect(@token.key_count).to eq(@keys_to_add)
      end
    end
  end

  describe '#add_pair!(key:, value:)' do
    before do
      @token = described_class.new(secret: 's3cr3t')
    end
    context 'when the key' do
      context 'is user_id' do
        context 'and the value' do
          context 'is valid' do
            it 'stores the value' do
              value = rand(1000)
              @token.add_pair!(key: :user_id, value: value)
              expect(@token.key_count).to eq(1)
              expect(@token.data[:user_id]).to eq(value)
            end
          end
          context 'is empty' do
            it 'raises an ArgumentError' do
              expect{@token.add_pair!(key: :user_id, value: nil)}.to raise_error ArgumentError
            end
          end
        end
      end
      context 'is email' do
        context 'and the value' do
          context 'is a valid email address' do
            it 'stores the value' do
              value = 'foo-%s@bar.com' % SecureRandom.uuid
              @token.add_pair!(key: :email, value: value)
              expect(@token.key_count).to eq(1)
              expect(@token.data[:email]).to eq(value)
            end
          end
          context 'is not a valid email address' do
            it 'raises an ArgumentError' do
              expect{@token.add_pair!(key: :email, value: 'invalid')}.to raise_error ArgumentError
            end
          end
        end
      end
      context 'is not a required key' do
        it 'allows empty values' do
          expect{@token.add_pair!(key: :foobar, value: nil)}.not_to raise_error
          expect(@token.data).to have_key :foobar
          expect(@token.data[:foobar]).to be_nil
        end
      end
    end
  end

  describe '#has_all_required_inputs?' do
    before do
      @token = described_class.new(secret: 's3cr3t')
    end
    context 'when all the required inputs' do
      context 'have been provided' do
        before do
          @token.add_pair!(key: :user_id, value: 123)
          @token.add_pair!(key: :email, value: 'foo@bar.com')
        end
        it 'returns true' do
          expect(@token.has_all_required_inputs?).to be true
        end
      end
      context 'have not been provided' do
        it 'returns false' do
          expect(@token.has_all_required_inputs?).to be false
        end
      end
    end
  end

  describe '#generate!' do
    before do
      @token = described_class.new(secret: 's3cr3t')
    end
    context 'when all the requires fields' do
      context 'have been provided' do
        before do
          @token.add_pair!(key: :user_id, value: 123)
          @token.add_pair!(key: :email, value: 'foo@bar.com')
        end
        it 'returns a token' do
          expect(@token.generate!).to be_a String
        end
      end
      context 'have not been provided' do
        it 'raises an exception' do
          expect{@token.generate!}.to raise_error JWT::ArgumentMissingError
        end
      end
    end
  end

end
