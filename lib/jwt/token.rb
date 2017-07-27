
module JWT
  class ArgumentMissingError < StandardError; end

  class Token
    REQUIRED_INPUTS = %w[user_id email].map(&:to_sym).freeze
    HEADER_JSON = { alg: 'HS256', typ: 'JWT' }.to_json
    HEADER = Base64.urlsafe_encode64(HEADER_JSON).gsub(/[\=\n]/, '').freeze

    attr_accessor :secret, :data
    def initialize(secret:)
      self.secret = secret
      self.data = {}
    end

    def key_count
      data.keys.count
    end

    def add_pair!(key:, value:)
      validate_pair!(key, value)
      @data.merge!(key => value)
    end

    def has_all_required_inputs?
      current_keys = data.keys.map(&:to_sym)
      REQUIRED_INPUTS.all? { |x| current_keys.include? x }
    end

    # See https://jwt.io/ for details and examples of JWT:
    def generate!
      raise ArgumentMissingError unless has_all_required_inputs?
      payload = Base64.urlsafe_encode64(data.to_json).gsub(/[\=\n]/, '')
      signature = Base64.urlsafe_encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          secret,
          HEADER + '.' + payload
        )
      ).strip.gsub(/[\=\n]/, '')
      [HEADER, payload, signature].join('.')
    end

    private

    def validate_pair!(key, value)
      case key.to_sym
      when :email
        # must be valid:
        raise ArgumentError unless EmailAddress.valid?(value, dns_lookup: :off)
      when :user_id
        # must be present:
        raise ArgumentError if value.to_s.empty?
      end
    end
  end
end
