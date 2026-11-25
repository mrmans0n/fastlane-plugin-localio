require 'rubygems'

spec = Gem::Specification.load(File.expand_path('../fastlane-plugin-localio.gemspec', __dir__))
fastlane = spec.development_dependencies.find { |dependency| dependency.name == 'fastlane' }
raise 'fastlane must be a development dependency' unless fastlane

requirement = fastlane.requirement
raise 'fastlane 2.237.0 must be allowed' unless requirement.satisfied_by?(Gem::Version.new('2.237.0'))
raise 'older fastlane versions must be excluded' if requirement.satisfied_by?(Gem::Version.new('2.236.0'))
raise 'Faraday 2 fastlane versions must be excluded' if requirement.satisfied_by?(Gem::Version.new('2.238.0'))

puts 'Dependency policy passed: fastlane 2.237.x only'
