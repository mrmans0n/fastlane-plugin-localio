describe Fastlane::Actions::LocalioAction do
  describe '#run' do
    before(:each) do
      allow(Fastlane::UI).to receive(:message)
    end

    context 'with a Locfile' do
      it 'runs localio from the Locfile' do
        locfile_path = File.expand_path('../fixtures/Locfile', __FILE__)
        FileUtils.mkdir_p(File.dirname(locfile_path))
        File.write(locfile_path, "# test Locfile")

        mock_config = double('Locfile')
        expect(Locfile).to receive(:load).with('Locfile').and_return(mock_config)
        expect(Localio).to receive(:from_configuration).with(mock_config)

        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            { locfile: locfile_path }
          )
        )

        FileUtils.rm_f(locfile_path)
      end

      it 'raises an error if Locfile does not exist' do
        expect do
          Fastlane::Actions::LocalioAction.run(
            FastlaneCore::Configuration.create(
              Fastlane::Actions::LocalioAction.available_options,
              { locfile: '/nonexistent/Locfile' }
            )
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /Locfile not found/)
      end
    end

    context 'with inline parameters' do
      let(:mock_config) { double('Locfile') }

      before(:each) do
        allow(Locfile).to receive(:new).and_return(mock_config)
        allow(mock_config).to receive(:platform)
        allow(mock_config).to receive(:source)
        allow(mock_config).to receive(:output_path)
        allow(mock_config).to receive(:formatting)
        allow(mock_config).to receive(:only)
        allow(mock_config).to receive(:except)
        allow(Localio).to receive(:from_configuration)
      end

      it 'generates Android localization from XLSX' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'android',
              source: 'xlsx',
              source_path: 'translations.xlsx',
              source_sheet: 'Sheet1',
              output_path: 'app/src/main/res'
            }
          )
        )

        expect(mock_config).to have_received(:platform).with(:android, {})
        expect(mock_config).to have_received(:source).with(:xlsx, { path: 'translations.xlsx', sheet: 'Sheet1' })
        expect(mock_config).to have_received(:output_path).with('app/src/main/res')
        expect(Localio).to have_received(:from_configuration).with(mock_config)
      end

      it 'generates iOS localization from Google Drive' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'ios',
              source: 'google_drive',
              source_path: 'My Translations',
              source_sheet: 'Main',
              output_path: 'Resources'
            }
          )
        )

        expect(mock_config).to have_received(:platform).with(:ios, {})
        expect(mock_config).to have_received(:source).with(:google_drive, { spreadsheet: 'My Translations', sheet: 'Main' })
        expect(mock_config).to have_received(:output_path).with('Resources')
      end

      it 'generates Swift localization with platform options' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'swift',
              source: 'csv',
              source_path: 'strings.csv',
              output_path: 'Generated',
              platform_options: { create_constants: false }
            }
          )
        )

        expect(mock_config).to have_received(:platform).with(:swift, { create_constants: false })
        expect(mock_config).to have_received(:source).with(:csv, { path: 'strings.csv' })
      end

      it 'passes formatting option' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'android',
              source: 'xls',
              source_path: 'test.xls',
              formatting: 'camel_case'
            }
          )
        )

        expect(mock_config).to have_received(:formatting).with(:camel_case)
      end

      it 'passes only and except filters' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'json',
              source: 'xlsx',
              source_path: 'test.xlsx',
              only: '[\[][a][\]]',
              except: '[\[][b][\]]'
            }
          )
        )

        expect(mock_config).to have_received(:only).with(keys: '[\[][a][\]]')
        expect(mock_config).to have_received(:except).with(keys: '[\[][b][\]]')
      end

      it 'merges source_options with source_path and source_sheet' do
        Fastlane::Actions::LocalioAction.run(
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            {
              platform: 'android',
              source: 'google_drive',
              source_path: 'My Sheet',
              source_sheet: '0',
              source_options: { client_id: 'id', client_secret: 'secret' }
            }
          )
        )

        expect(mock_config).to have_received(:source).with(
          :google_drive,
          { client_id: 'id', client_secret: 'secret', spreadsheet: 'My Sheet', sheet: '0' }
        )
      end

      it 'raises an error without platform' do
        expect do
          Fastlane::Actions::LocalioAction.run(
            FastlaneCore::Configuration.create(
              Fastlane::Actions::LocalioAction.available_options,
              { source: 'xlsx', source_path: 'test.xlsx' }
            )
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /platform.*required/i)
      end

      it 'raises an error without source' do
        expect do
          Fastlane::Actions::LocalioAction.run(
            FastlaneCore::Configuration.create(
              Fastlane::Actions::LocalioAction.available_options,
              { platform: 'android' }
            )
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /source.*required/i)
      end

      it 'rejects invalid platform' do
        expect do
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            { platform: 'invalid', source: 'xlsx' }
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /Invalid platform/)
      end

      it 'rejects invalid source' do
        expect do
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            { platform: 'android', source: 'invalid' }
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /Invalid source/)
      end

      it 'rejects invalid formatting' do
        expect do
          FastlaneCore::Configuration.create(
            Fastlane::Actions::LocalioAction.available_options,
            { platform: 'android', source: 'xlsx', formatting: 'invalid' }
          )
        end.to raise_error(FastlaneCore::Interface::FastlaneError, /Invalid formatting/)
      end
    end
  end

  describe 'metadata' do
    it 'has a description' do
      expect(Fastlane::Actions::LocalioAction.description).not_to be_empty
    end

    it 'has authors' do
      expect(Fastlane::Actions::LocalioAction.authors).to include('Nacho Lopez')
    end

    it 'is supported on all platforms' do
      expect(Fastlane::Actions::LocalioAction.is_supported?(:ios)).to be true
      expect(Fastlane::Actions::LocalioAction.is_supported?(:android)).to be true
    end

    it 'has available options' do
      expect(Fastlane::Actions::LocalioAction.available_options).not_to be_empty
    end
  end
end
