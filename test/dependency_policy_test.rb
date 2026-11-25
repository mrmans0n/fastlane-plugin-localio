require 'rubygems'

spec = Gem::Specification.load(File.expand_path('../fastlane-plugin-localio.gemspec', __dir__))
fastlane = spec.development_dependencies.find { |dependency| dependency.name == 'fastlane' }
raise 'fastlane must be a development dependency' unless fastlane

requirement = fastlane.requirement
raise 'fastlane 2.237.0 must be allowed' unless requirement.satisfied_by?(Gem::Version.new('2.237.0'))
raise 'older fastlane versions must be excluded' if requirement.satisfied_by?(Gem::Version.new('2.236.0'))
raise 'Faraday 2 fastlane versions must be excluded' if requirement.satisfied_by?(Gem::Version.new('2.238.0'))

require 'json'

renovate = JSON.parse(File.read(File.expand_path('../renovate.json', __dir__)))
rule = renovate.fetch('packageRules', []).find do |candidate|
  candidate.fetch('matchPackageNames', []) == ['fastlane'] &&
    candidate.fetch('matchManagers', []) == ['gemspec']
end
raise 'Renovate must preserve fastlane compatibility' unless rule

allowed_versions = Gem::Requirement.new(rule.fetch('allowedVersions'))
raise 'Renovate must allow fastlane 2.237.0' unless allowed_versions.satisfied_by?(Gem::Version.new('2.237.0'))
raise 'Renovate must allow compatible patch updates' unless allowed_versions.satisfied_by?(Gem::Version.new('2.237.1'))
raise 'Renovate must exclude incompatible fastlane' if allowed_versions.satisfied_by?(Gem::Version.new('2.238.0'))
raise 'Renovate must exclude the proposed incompatible update' if allowed_versions.satisfied_by?(Gem::Version.new('2.242.0'))

puts 'Dependency policy passed: fastlane 2.237.x only, including Renovate updates'
