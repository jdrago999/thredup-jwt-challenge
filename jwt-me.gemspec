Gem::Specification.new do |spec|
  spec.name        = 'jwt-me'
  spec.version     = '0.1.0'
  spec.authors     = ['John Drago']
  spec.email       = 'jdrago.999@gmail.com'
  spec.homepage    = 'https://github.com/jdrago999/thredup-jwt-challenge'
  spec.summary     = 'ThredUP JWT Challenge'
  spec.description = 'A CLI for generating JSON Web Tokens'
  spec.required_rubygems_version = '>= 1.3.6'
  spec.required_ruby_version = '~> 2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'email_address', '0.1.3'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'activesupport', '~> 4'
  spec.add_development_dependency 'shoulda-matchers', '3.1.2'
  spec.add_development_dependency 'byebug', '9.0.6'
  spec.add_development_dependency 'simplecov', '0.14.1'
  spec.add_development_dependency 'rubocop', '0.49.1'
end
