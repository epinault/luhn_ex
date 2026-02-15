# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Modernized `mix.exs` configuration (renamed module to `Luhn.MixProject`, updated deps)
- Made `double/3` private — it was an internal implementation detail exposed publicly
- Improved `@doc` and `@spec` annotations across all public functions
- Updated CI to test against Elixir 1.15–1.18 and OTP 25–27
- Minimum Elixir version bumped to 1.13

### Added

- `.formatter.exs` for enforced code formatting
- Credo for static analysis (`mix credo --strict`)
- Dialyxir for type checking (`mix dialyzer`)
- `CHANGELOG.md` (this file)
- Doctest integration in test suite
- Edge case tests (single digit, error handling)

### Removed

- `power_assert` dependency (unmaintained, unused)
- `benchfella` dependency (replaced by standard benchmarking)

## [0.3.3] - 2019-08-18

### Added

- Guard clause for base validation (`base >= 2`)
- `ex_doc` dependency for documentation generation

### Changed

- Refactored to use `Integer.digits/2` and `Enum.reverse/1`

## [0.3.2] - 2016-09-01

### Added

- Hexadecimal (base 16) support
- Arbitrary base support for Luhn validation

## [0.3.1] - 2015-07-28

### Added

- Support for integer input (in addition to strings)

## [0.3.0] - 2015-07-03

### Changed

- Performance improvements

## [0.2.0] - 2015-06-29

### Added

- `checksum/2` function

## [0.1.0] - 2015-06-26

### Added

- Initial release
- `valid?/1` function for Luhn number validation
