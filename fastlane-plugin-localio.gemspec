lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/localio/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-localio'
  spec.version       = Fastlane::Localio::VERSION
  spec.author        = 'Nacho Lopez'
  spec.email         = 'nacho@nlopez.io'
  spec.summary       = 'Fastlane plugin for the localio gem'
  spec.description   = 'Generates localization files from spreadsheets using the localio gem. ' \
                        'Supports Google Drive, XLS, XLSX, and CSV sources with output for ' \
                        'Android, iOS, Swift, Rails, JSON, Java Properties, RESX, and Twine.'
  spec.homepage      = 'https://github.com/mrmans0n/fastlane-plugin-localio'
  spec.license       = 'MIT'

  spec.files         = Dir["lib/**/*"] + %w[README.md LICENSE]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'localio', '>= 0.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fastlane', '>= 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
