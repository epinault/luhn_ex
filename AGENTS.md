# AGENTS.md

`luhn` is a tiny, dependency-free Elixir library that validates numbers with the Luhn (mod 10) checksum, with optional arbitrary base. It is used by other Elixir projects for credit card, IMEI and similar ID validation. Published to hex.pm as `:luhn`; this repo is the upstream (`origin` = `git@github.com:epinault/luhn_ex`, default branch `master`). There is no deploy target, only hex releases.

## Project Overview

| Item | Value |
|------|-------|
| Language | Elixir `~> 1.13` (mix.exs); dev toolchain Elixir 1.20.4 / OTP 29.0.5 (`.tool-versions`, `mise.toml`) |
| App / module | `:luhn` / `Luhn` (single module, `lib/luhn.ex`); project module `Luhn.MixProject` |
| Version | `@version` in mix.exs (currently 0.4.0) |
| Runtime deps | none |
| Dev/test deps | credo ~> 1.7, dialyxir ~> 1.4, ex_doc ~> 0.34 (dev), benchee ~> 1.3 (dev) |
| CI | GitHub Actions (`.github/workflows/elixir.yml`, `publish.yml`) |
| Docs | ExDoc, main page `Luhn`, extras CHANGELOG.md + CONTRIBUTING.md |

## Essential Commands

```bash
# Setup
mise install            # or: asdf install (reads .tool-versions)
mix deps.get

# Test
mix test
mix test test/luhn_test.exs
mix test test/luhn_test.exs:12      # single test by line
mix test --warnings-as-errors --cover   # what CI runs; coverage threshold 80%

# Quality (mirror CI; there is NO precommit alias)
mix format --check-formatted
mix compile --warnings-as-errors
mix credo --strict
mix dialyzer            # not in CI, but listed in CONTRIBUTING.md

# Other
mix docs                # build ExDoc into doc/
mix run bench/bench.exs # Benchee benchmark
```

Quality gate before committing: `mix format --check-formatted && mix compile --warnings-as-errors && mix credo --strict && mix test --warnings-as-errors --cover` (plus `mix dialyzer` if you touched specs).

## Architecture

```
lib/luhn.ex          # whole library: Luhn.valid?/2, Luhn.checksum/2, private double/3, sum/2
test/luhn_test.exs   # one ExUnit module: doctest Luhn + example tests
test/test_helper.exs # ExUnit.start()
bench/bench.exs      # Benchee script (dev only)
.github/workflows/   # elixir.yml (CI), publish.yml (hex publish on tag)
```

- No supervision tree, no `application.ex`, no config/ directory, no processes. Pure functions only.
- Public API (both have `@doc` + `@spec`):
  - `Luhn.valid?(integer() | String.t(), pos_integer()) :: boolean()` (base defaults to 10)
  - `Luhn.checksum(integer() | String.t(), pos_integer()) :: non_neg_integer()` (0 means valid)
- Strings are parsed with `String.to_integer(str, base)`, so non-numeric input raises `ArgumentError`; integers go through `Integer.digits/2`, reversed, then doubled on alternate positions by private `double/3`. `sum/2` folds a doubled value >= base back into a single digit (`n - base + 1`).
- `defguardp valid_base/1` requires an integer base >= 2; an invalid base fails guard matching (`FunctionClauseError`), see the "invalid base" tests.

## Conventions

- Formatter: default `mix format`, inputs `{mix,.formatter}.exs` and `{config,lib,test}/**`.
- Credo: `strict: true`, max line length 120, `Readability.ModuleDoc` on, `LargeNumbers` excluded for `test/` (tests group card numbers with underscores like `4111_1111_1111_1111`; lib code follows Credo's default rule).
- Every public function needs `@doc`, `@spec`, and a `## Examples` section written as doctests. `@moduledoc` examples are also doctests.
- Keep the library dependency-free. New deps may only be `only: [:dev, :test]`.
- Do not re-expose `double/3`; it was made private in 0.4.0 on purpose.
- Errors: invalid input raises (no `{:ok, _}`/`{:error, _}` tuples in this API); keep that unless it is a deliberate, versioned API change.

## Testing

- `test/luhn_test.exs` is `use ExUnit.Case, async: true` and starts with `doctest Luhn`, so every `iex>` example in `lib/luhn.ex` is a test. Wrong doctest values fail CI (0.4.0 fixed several).
- Hand-written tests are grouped by `describe`: card numbers by issuer, integer input, invalid numbers, hexadecimal base, invalid base, `checksum/2`. Add new cases to the matching `describe`.
- No property tests, no Mox, no fixtures. If adding StreamData, make it `only: :test` and note it in the CHANGELOG.
- Coverage: built-in `mix test --cover`, `test_coverage: [threshold: 80]` in mix.exs.
- Example style:

```elixir
test "Discover" do
  assert Luhn.valid?("6011111111111117")
end
```

## Elixir Guidelines

- CI matrix (elixir.yml, ubuntu-24.04, fail-fast off): Elixir/OTP 1.20/29.0, 1.20/28.0, 1.19/28.0, 1.19/27.2, 1.18/27.2, 1.17/27.0. Separate `format` job on 1.20/29.0.
- mix.exs still declares `elixir: "~> 1.13"` while CI only covers 1.17+. Do not use syntax or stdlib functions newer than 1.13 without raising that requirement (and the CHANGELOG saying so).
- Prefer pattern matching and guards over `if`/`case` chains; keep `valid_base` guarding every public clause.
- Never call `String.to_atom/1` on input; no `Process.sleep` in tests.
- Warnings are errors in CI (`--warnings-as-errors`); new compiler warnings on 1.20 will break the build.

## Workflow for Agents

1. Read `lib/luhn.ex` and the relevant `describe` in `test/luhn_test.exs`.
2. Add or adjust a test (or doctest) first, then change the code.
3. Run the quality gate above.
4. Update `CHANGELOG.md` under `## [Unreleased]` (Keep a Changelog sections: Added/Changed/Fixed/Removed) for any user-visible change.
5. Commits: conventional style (`ci:`, `chore:`, `build(deps):`, `fix:`), branch from `master`, merge via GitHub PR (`.github/pull_request_template.md`). Commit only when asked.

### Releasing to hex

1. Move `[Unreleased]` entries into a new `## [x.y.z] - YYYY-MM-DD` section in CHANGELOG.md.
2. Bump `@version` in mix.exs (also drives `source_ref: "v#{@version}"` in docs) and the README install snippet if the minor changes (README currently says `~> 0.3`).
3. Merge to `master`, then push a tag (any tag; `publish.yml` triggers on `*`, use `vX.Y.Z`). The workflow publishes using the `HEX_API_KEY` repo secret. Never run `mix hex.publish` locally unless asked.

## Constraints — Never Do

- Never skip the quality gate or use `--no-verify`.
- Never edit `mix.lock` by hand; use `mix deps.update`.
- Never add runtime dependencies.
- Never change `valid?/2` or `checksum/2` signatures or raise behaviour without a CHANGELOG entry and a semver-appropriate bump.
- No committed `IO.inspect`, `dbg`, or `erl_crash.dump` (it is gitignored).
- Never commit secrets or hex API keys; never push tags unless asked (a tag publishes to hex).
- Do not hand-edit `doc/`, `_build/`, `deps/` (gitignored).

## Gotchas

- `checksum/2` for a string uses `String.to_integer/2`, which is case-insensitive for hex but raises on any non-digit (spaces, dashes). Callers must strip formatting first.
- Leading zeros in strings are lost by integer conversion; this can matter for the doubling position of odd/even length inputs.
- CONTRIBUTING.md says asdf; the repo also has `mise.toml`. Keep both tool-version files in sync when bumping.
- `.claude/settings.local.json` is a local permission allowlist, not project config.
- Default branch is `master`, not `main`.

## Key Files

- `lib/luhn.ex` - the entire implementation, docs, and doctests
- `test/luhn_test.exs` - tests and `doctest Luhn`
- `mix.exs` - version, Elixir requirement, package/docs config, coverage threshold
- `CHANGELOG.md` - Keep a Changelog; update on every user-visible change
- `.github/workflows/elixir.yml` - CI matrix and exact check commands
- `.github/workflows/publish.yml` - tag-triggered hex publish
- `.credo.exs`, `.formatter.exs` - style enforcement
- `.tool-versions`, `mise.toml` - pinned local toolchain
- `CONTRIBUTING.md`, `README.md` - contributor and user docs
- `bench/bench.exs` - benchmark script
