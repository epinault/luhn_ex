# Contributing to Luhn

We welcome contributions! This document provides guidelines and instructions
for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/luhn_ex.git
   cd luhn_ex
   ```
3. Install dependencies:
   ```bash
   mix deps.get
   ```
4. Make sure existing tests pass:
   ```bash
   mix test
   ```

## Development Setup

We use [asdf](https://asdf-vm.com/) for managing Elixir and Erlang versions.
A `.tool-versions` file is included in the repository. Install the correct
versions with:

```bash
asdf install
```

## Making Changes

1. Create a topic branch from `master`:
   ```bash
   git checkout -b my-feature master
   ```
2. Make your changes in logical commits
3. Add or update tests as needed
4. Ensure all checks pass before submitting:
   ```bash
   mix test
   mix format --check-formatted
   mix credo --strict
   mix dialyzer
   ```

## Code Style

- Run `mix format` before committing — CI enforces formatting
- Follow [Credo](https://github.com/rrrene/credo) suggestions (`mix credo --strict`)
- Add `@doc` and `@spec` to all public functions
- Use doctests for simple examples

## Running Benchmarks

```bash
mix run bench/bench.exs
```

## Pull Requests

- Keep PRs focused — one feature or fix per PR
- Update `CHANGELOG.md` under the `[Unreleased]` section
- Write a clear PR description explaining **what** and **why**
- Link any related issues
- Large changes should be discussed in an issue first

## Bug Reports

When filing a bug report, please include:

- Elixir and OTP versions (`elixir --version`)
- Luhn version
- Steps to reproduce
- Expected vs actual behavior

## License

By contributing, you agree that your contributions will be licensed under the
MIT License.
