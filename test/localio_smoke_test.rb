# Run in its own Ruby process, without spec_helper's Localio and Locfile stubs.
require 'json'
require 'tmpdir'
require 'fastlane'
require 'fastlane/plugin/localio'

Dir.mktmpdir('localio-smoke-') do |directory|
  source = File.join(directory, 'translations.csv')
  output = File.join(directory, 'locales')
  File.write(source, "Translations,,\n[key],*en,es\ngreeting,Hello,Hola\n[end],,\n")

  action = Fastlane::Actions::LocalioAction
  action.run(FastlaneCore::Configuration.create(action.available_options, {
    platform: 'json',
    source: 'csv',
    source_path: source,
    output_path: output
  }))

  { 'en' => 'Hello', 'es' => 'Hola' }.each do |language, greeting|
    path = File.join(output, "strings-#{language}.json")
    actual = JSON.parse(File.read(path))
    expected = { 'greeting' => greeting }
    raise "Unexpected #{language} translations: #{actual.inspect}" unless actual.fetch('translations') == expected
    raise "Unexpected language metadata: #{actual.inspect}" unless actual.fetch('meta').fetch('language') == language
  end
end

puts 'CSV to JSON smoke test passed for en and es'
