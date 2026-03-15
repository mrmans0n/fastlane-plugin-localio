require 'fastlane/plugin/localio/version'

module Fastlane
  module Localio
    def self.all_classes
      Dir[File.expand_path('*/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

Fastlane::Localio.all_classes.each do |current|
  require current
end
