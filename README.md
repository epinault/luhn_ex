# Luhn

[![hex.pm version](https://img.shields.io/hexpm/v/luhn.svg)](https://hex.pm/packages/luhn)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/luhn.svg)](https://hex.pm/packages/luhn)
[![CI](https://github.com/epinault/luhn_ex/workflows/CI/badge.svg?branch=master)](https://github.com/epinault/luhn_ex/actions?query=workflow%3ACI)

Luhn algorithm implementation in Elixir for validating credit card numbers,
IMEI numbers, and other identification numbers that use the Luhn checksum.

Supports arbitrary bases (decimal, hexadecimal, etc.).

## Installation

Add `luhn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:luhn, "~> 0.3"}
  ]
end
```

## Usage

```elixir
# Validate a credit card number (string)
Luhn.valid?("378282246310005")
# => true

# Also works with integers
Luhn.valid?(4111111111111111)
# => true

# Hexadecimal support
Luhn.valid?("abc1239", 16)
# => true

# Get the checksum value
Luhn.checksum("378282246310005")
# => 0
```

## Documentation

Full documentation is available on [HexDocs](https://hexdocs.pm/luhn).

## License

MIT — see [LICENSE.txt](LICENSE.txt) for details.
