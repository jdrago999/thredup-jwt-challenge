
module JWT
  #
  class App
    attr_accessor :token

    def run!(secret:)
      warn 'Starting with JWT token generation.'
      self.token = JWT::Token.new(secret: secret)
      collect_input until token.has_all_required_inputs?
      collect_additional_inputs
      copy_to_clipboard(token.generate!)
      warn 'The JWT has been copied to your clipboard!'
    end

    private

    def copy_to_clipboard(input)
      IO.popen('pbcopy', 'w') { |f| f << input.to_s }
    end

    def collect_additional_inputs
      loop do
        warn 'Any additional inputs? (yes/no)'
        answer = $stdin.gets.chomp
        case answer
        when 'no'
          break
        when 'yes'
          collect_input
          next
        end
        warn 'Invalid answer "%s"' % answer
      end
    end

    def collect_input
      warn 'Enter key %d' % [token.key_count + 1]
      key = $stdin.gets.chomp
      begin
        warn 'Enter %s value' % key
        value = $stdin.gets.chomp
        token.add_pair!(key: key, value: value)
      rescue ArgumentError
        warn 'Invalid %s entered! Enter %s value' % [key, key]
        retry
      end
    end
  end
end
