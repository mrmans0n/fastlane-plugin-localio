require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class LocalioHelper
      VALID_PLATFORMS = %i[android ios swift rails json java_properties resx twine].freeze
      VALID_SOURCES = %i[google_drive xls xlsx csv].freeze
      VALID_FORMATTING = %i[smart snake_case camel_case none].freeze

      def self.require_localio!
        return if defined?(::Locfile) && ::Locfile.method_defined?(:platform)

        begin
          require 'localio'
        rescue LoadError
          UI.user_error!("The 'localio' gem is required. Add `gem 'localio'` to your Gemfile.")
        end
      end

      def self.build_configuration(params)
        config = Locfile.new

        platform_sym = params[:platform].to_sym
        platform_opts = params[:platform_options] || {}
        config.platform(platform_sym, platform_opts)

        source_sym = params[:source].to_sym
        source_opts = build_source_options(params)
        config.source(source_sym, source_opts)

        config.output_path(params[:output_path]) if params[:output_path]
        config.formatting(params[:formatting].to_sym) if params[:formatting]

        config.only(keys: params[:only]) if params[:only]
        config.except(keys: params[:except]) if params[:except]

        config
      end

      def self.build_source_options(params)
        opts = {}
        opts.merge!(params[:source_options]) if params[:source_options]

        case params[:source].to_sym
        when :google_drive
          opts[:spreadsheet] ||= params[:source_path]
          opts[:sheet] ||= params[:source_sheet]
        when :xls, :xlsx
          opts[:path] ||= params[:source_path]
          opts[:sheet] ||= params[:source_sheet]
        when :csv
          opts[:path] ||= params[:source_path]
        end

        opts
      end
    end
  end
end
