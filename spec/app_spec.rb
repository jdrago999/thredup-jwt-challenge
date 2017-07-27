require 'spec_helper'

describe JWT::App do
  before do
    @app = described_class.new
  end
  describe '#run!' do
    it 'creates a new token' do
      expect(JWT::Token).to receive(:new)
      @app.run!(secret: 'foo')
    end
  end
end
