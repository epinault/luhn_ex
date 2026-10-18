# CLAUDE.md

Claude Code guidance for this repository. The canonical agent instructions live in AGENTS.md.

@AGENTS.md

## Plugin Setup

```bash
claude plugin install elixir@claude-code-elixir
claude plugin install superpowers@claude-plugins-official
claude plugin install code-review@claude-plugins-official
```

## Claude-specific notes

- This is a one-module library: skip heavy planning ceremony; use `superpowers:test-driven-development` for behaviour changes and `superpowers:verification-before-completion` before claiming the gate passes.
- Use `/code-review` before opening a PR; `update-dependencies` skill for dep bumps (mix.lock changes only via mix).
- `.claude/settings.local.json` is machine-local; do not treat it as shared config.
