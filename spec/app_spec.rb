require 'spec_helper'

describe JWT::App do
  before do
    @app = described_class.new
  end

  describe '#run!' do
    it 'creates a new token' do
      fake_token = double('token')
      expect(fake_token).to receive(:has_all_required_inputs?).ordered.and_return(false)
      expect(fake_token).to receive(:has_all_required_inputs?).ordered.and_return(true)
      expect(JWT::Token).to receive(:new).and_return(fake_token)
      expect(@app).to receive(:collect_input)
      expect(@app).to receive(:collect_additional_inputs)
      expect(fake_token).to receive(:generate!)
      expect(@app).to receive(:copy_to_clipboard)
      @app.run!(secret: 'foo')
    end
  end

  describe '#copy_to_clipboard(input)' do
    it 'copies a string to the clipboard' do
      fake_clipboard = [ ]
      expect(IO).to receive(:popen).with('pbcopy', 'w') do |&block|
        block.call(fake_clipboard)
      end
      string_to_copy = SecureRandom.uuid
      @app.send(:copy_to_clipboard, string_to_copy)
      expect(fake_clipboard).to include string_to_copy
    end
  end

  describe '#collect_input' do
    before do
      @app.token = JWT::Token.new(secret: 's3cr3t')
    end
    it 'shows the correct prompts' do
      key_count = rand(100)
      key_count.times { |n| @app.token.add_pair!(key: "Key#{n}", value: 0) }
      expect(@app).to receive(:warn).ordered.with('Enter key %d' % [key_count + 1])
      key_name = SecureRandom.uuid
      expect($stdin).to receive(:gets).ordered.and_return(key_name)
      expect(@app).to receive(:warn).ordered.with('Enter %s value' % key_name)
      expect($stdin).to receive(:gets).ordered.and_return('foo')
      @app.send(:collect_input)
    end
    context 'when the key/value pair is invalid' do
      it 'shows a warning and tries again' do
        expect(@app).to receive(:warn).ordered
        expect($stdin).to receive(:gets).ordered.and_return('email')
        expect(@app).to receive(:warn).ordered
        expect($stdin).to receive(:gets).ordered.and_return('invalid-email')
        expect(@app).to receive(:warn).ordered
        expect(@app).to receive(:warn).ordered
        expect($stdin).to receive(:gets).ordered.and_return('valid@email.com')
        @app.send(:collect_input)
        expect(@app.token.data['email']).to eq('valid@email.com')
      end
    end
  end

  describe '#collect_additional_inputs' do
    context 'after asking if there are any additional inputs' do
      before do
        expect(@app).to receive(:warn).with(%r{yes/no})
      end
      context 'if the answer is no' do
        it 'stops asking' do
          expect($stdin).to receive(:gets).and_return('no')
          expect(@app.send(:collect_additional_inputs)).to be_nil
        end
      end
      context 'if the answer is yes' do
        it 'tries to collect more input, then asks again' do
          expect($stdin).to receive(:gets).ordered.and_return('yes')
          expect(@app).to receive(:collect_input).ordered
          expect(@app).to receive(:warn).ordered.with(%r{Any additional})
          expect($stdin).to receive(:gets).ordered.and_return('no')
          expect(@app.send(:collect_additional_inputs)).to be_nil
        end
      end
      context 'if it does not understand the answer' do
        it 'complains asks again' do
          expect($stdin).to receive(:gets).ordered.and_return('foobar')
          expect(@app).to receive(:warn).ordered.with(%r{Invalid answer})
          expect(@app).to receive(:warn).ordered.with(%r{Any additional})
          expect($stdin).to receive(:gets).ordered.and_return('no')
          expect(@app.send(:collect_additional_inputs)).to be_nil
        end
      end
    end
  end
end
