require 'fastlane/action'
require_relative '../helper/localio_helper'

module Fastlane
  module Actions
    class LocalioAction < Action
      def self.run(params)
        if params[:locfile]
          run_with_locfile(params[:locfile])
        else
          run_with_params(params)
        end
      end

      def self.run_with_locfile(locfile_path)
        Helper::LocalioHelper.require_localio!

        UI.message("Running localio with Locfile: #{locfile_path}")

        unless File.exist?(locfile_path)
          UI.user_error!("Locfile not found at path: #{locfile_path}")
        end

        Dir.chdir(File.dirname(File.expand_path(locfile_path))) do
          config = ::Locfile.load(File.basename(locfile_path))
          ::Localio.from_configuration(config)
        end
      end

      def self.run_with_params(params)
        unless params[:platform]
          UI.user_error!("Parameter 'platform' is required when not using a Locfile")
        end

        unless params[:source]
          UI.user_error!("Parameter 'source' is required when not using a Locfile")
        end

        Helper::LocalioHelper.require_localio!

        UI.message("Running localio with inline configuration (platform: #{params[:platform]}, source: #{params[:source]})")

        config = Helper::LocalioHelper.build_configuration(params)
        ::Localio.from_configuration(config)
      end

      def self.description
        "Generates localization files from spreadsheets using the localio gem"
      end

      def self.authors
        ["Nacho Lopez"]
      end

      def self.return_value
        nil
      end

      def self.details
        "Reads translation data from spreadsheets (Google Drive, XLS, XLSX, CSV) " \
          "and generates platform-specific localization files using the localio gem. " \
          "Supports two modes: Locfile-based (simple) and inline parameters (no Locfile needed)."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :locfile,
            env_name: "LOCALIO_LOCFILE",
            description: "Path to an existing Locfile. If provided, all other parameters are ignored",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: "LOCALIO_PLATFORM",
            description: "Target platform (android, ios, swift, rails, json, java_properties, resx, twine)",
            optional: true,
            type: String,
            verify_block: proc do |value|
              unless Helper::LocalioHelper::VALID_PLATFORMS.include?(value.to_sym)
                UI.user_error!("Invalid platform '#{value}'. Valid: #{Helper::LocalioHelper::VALID_PLATFORMS.join(', ')}")
              end
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :source,
            env_name: "LOCALIO_SOURCE",
            description: "Source type (google_drive, xls, xlsx, csv)",
            optional: true,
            type: String,
            verify_block: proc do |value|
              unless Helper::LocalioHelper::VALID_SOURCES.include?(value.to_sym)
                UI.user_error!("Invalid source '#{value}'. Valid: #{Helper::LocalioHelper::VALID_SOURCES.join(', ')}")
              end
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :source_path,
            env_name: "LOCALIO_SOURCE_PATH",
            description: "Path to the source file (XLS/XLSX/CSV) or spreadsheet title (Google Drive)",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :source_sheet,
            env_name: "LOCALIO_SOURCE_SHEET",
            description: "Sheet name or index within the spreadsheet",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :source_options,
            env_name: "LOCALIO_SOURCE_OPTIONS",
            description: "Additional source options as a hash (merged with source_path/source_sheet)",
            optional: true,
            type: Hash
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_path,
            env_name: "LOCALIO_OUTPUT_PATH",
            description: "Output directory for generated localization files",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :formatting,
            env_name: "LOCALIO_FORMATTING",
            description: "Key formatting style (smart, snake_case, camel_case, none)",
            optional: true,
            default_value: "smart",
            type: String,
            verify_block: proc do |value|
              unless Helper::LocalioHelper::VALID_FORMATTING.include?(value.to_sym)
                UI.user_error!("Invalid formatting '#{value}'. Valid: #{Helper::LocalioHelper::VALID_FORMATTING.join(', ')}")
              end
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :platform_options,
            env_name: "LOCALIO_PLATFORM_OPTIONS",
            description: "Additional platform options as a hash (e.g. { create_constants: false })",
            optional: true,
            type: Hash
          ),
          FastlaneCore::ConfigItem.new(
            key: :only,
            env_name: "LOCALIO_ONLY",
            description: "Regex filter to include only matching keys",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :except,
            env_name: "LOCALIO_EXCEPT",
            description: "Regex filter to exclude matching keys",
            optional: true,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :misc
      end
    end
  end
end
