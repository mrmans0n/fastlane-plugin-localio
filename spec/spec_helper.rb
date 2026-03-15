$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'fastlane'
require 'fastlane/plugin/localio'

# Stub localio gem classes for testing
unless defined?(Localio)
  module Localio
    def self.from_locfile(path); end
    def self.from_configuration(config); end
  end
end

unless defined?(Locfile)
  class Locfile
    attr_accessor :output_path, :formatting, :only, :except
    def platform(*args); end
    def source(*args); end
  end
end

Fastlane.load_actions
