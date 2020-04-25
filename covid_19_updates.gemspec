# frozen_string_literal: true

require_relative 'lib/covid_19_updates/version'

Gem::Specification.new do |spec|
  spec.name          = 'covid_19_updates'
  spec.version       = Covid19Updates::VERSION
  spec.authors       = ['Jack Madden']
  spec.email         = ['jck13mad@gmail.com']

  spec.summary       = 'Find out the latest on the Covd-19 Pandemic.'
  spec.description   = 'Find out the latest on the Covd-19 Pandemic.'
  spec.homepage      = 'https://rubygems.org/'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://rubygems.org/'
  spec.metadata['changelog_uri'] = 'https://rubygems.org/'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'Nokogiri'
  spec.add_dependency 'thor', '>= 1.0.1'
end
