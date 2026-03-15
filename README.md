# fastlane-plugin-localio

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/mrmans0n/fastlane-plugin-localio/blob/main/LICENSE)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-localio.svg)](https://badge.fury.io/rb/fastlane-plugin-localio)

Fastlane plugin for the [localio](https://github.com/mrmans0n/localio) gem. Generates localization files from spreadsheets (Google Drive, XLS, XLSX, CSV) for multiple platforms (Android, iOS, Swift, Rails, JSON, Java Properties, RESX, Twine).

## Installation

Add to your project's `Gemfile`:

```ruby
gem "fastlane-plugin-localio"
```

Or install via fastlane:

```bash
fastlane add_plugin localio
```

## Usage

The plugin supports two modes of operation.

### Mode 1: Locfile-based (simple)

If you already have a `Locfile` configured for localio, just point to it:

```ruby
localio(locfile: "path/to/Locfile")
```

### Mode 2: Inline parameters

Configure everything directly in your Fastfile without needing a separate Locfile:

```ruby
localio(
  platform: "android",
  source: "xlsx",
  source_path: "translations.xlsx",
  source_sheet: "Sheet1",
  output_path: "app/src/main/res",
  formatting: "smart"
)
```

## Source types

### XLSX

```ruby
localio(
  platform: "android",
  source: "xlsx",
  source_path: "translations.xlsx",
  source_sheet: "Sheet1",
  output_path: "app/src/main/res"
)
```

### XLS

```ruby
localio(
  platform: "ios",
  source: "xls",
  source_path: "translations.xls",
  source_sheet: "Translations",
  output_path: "Resources"
)
```

### CSV

```ruby
localio(
  platform: "json",
  source: "csv",
  source_path: "translations.csv",
  output_path: "locales",
  source_options: { column_separator: ";" }
)
```

### Google Drive

```ruby
localio(
  platform: "android",
  source: "google_drive",
  source_path: "My Translations Spreadsheet",
  source_sheet: "Sheet1",
  source_options: {
    client_id: "your_client_id",
    client_secret: "your_client_secret",
    client_token: "path/to/token.json"
  },
  output_path: "app/src/main/res"
)
```

## Platforms

| Platform | Key | Description |
|----------|-----|-------------|
| Android | `android` | Generates `strings.xml` resource files |
| iOS | `ios` | Generates `.strings` files |
| Swift | `swift` | Generates Swift constants |
| Rails | `rails` | Generates YAML locale files |
| JSON | `json` | Generates JSON locale files |
| Java Properties | `java_properties` | Generates `.properties` files |
| RESX | `resx` | Generates `.resx` resource files |
| Twine | `twine` | Generates Twine format files |

## Platform options

Pass platform-specific options via the `platform_options` parameter:

```ruby
localio(
  platform: "swift",
  source: "xlsx",
  source_path: "translations.xlsx",
  output_path: "Generated",
  platform_options: {
    create_constants: false,
    override_default: "es"
  }
)
```

## Formatting

Control how translation keys are formatted:

| Style | Key |
|-------|-----|
| Smart (default) | `smart` |
| Snake Case | `snake_case` |
| Camel Case | `camel_case` |
| None | `none` |

```ruby
localio(
  platform: "android",
  source: "xlsx",
  source_path: "translations.xlsx",
  output_path: "res",
  formatting: "camel_case"
)
```

## Filtering

Use `only` and `except` to filter which keys are processed:

```ruby
localio(
  platform: "android",
  source: "xlsx",
  source_path: "translations.xlsx",
  output_path: "res",
  only: '[\[][a][\]]',
  except: '[\[][b][\]]'
)
```

## Parameters

| Key | Description | Default |
|-----|-------------|---------|
| `locfile` | Path to an existing Locfile | |
| `platform` | Target platform | |
| `source` | Source type (google_drive, xls, xlsx, csv) | |
| `source_path` | Path to source file or spreadsheet title | |
| `source_sheet` | Sheet name or index | |
| `source_options` | Additional source options hash | |
| `output_path` | Output directory | |
| `formatting` | Key formatting style | `smart` |
| `platform_options` | Additional platform options hash | |
| `only` | Regex filter to include only matching keys | |
| `except` | Regex filter to exclude matching keys | |

## License

MIT. See [LICENSE](LICENSE).
