# agents

Global configuration for coding agents.

| Repo file | Linked to | Used by |
|---|---|---|
| `dot-agents/AGENTS.md` (the real file) | `~/.agents/AGENTS.md` | shared source for every agent |
| `dot-claude/CLAUDE.md` → `../dot-agents/AGENTS.md` | `~/.claude/CLAUDE.md` | Claude Code |
| `dot-codex/AGENTS.md` → `../dot-agents/AGENTS.md` | `~/.codex/AGENTS.md` | Codex |

All agents read the same instructions, so edit `dot-agents/AGENTS.md` only.
To add another agent, add a symlink to `../dot-agents/AGENTS.md` (or to
`~/.agents/AGENTS.md`) at the path that agent reads, then restow. For example,
opencode reads `~/.config/opencode/AGENTS.md`.

This package is stowed with `--no-folding`. `~/.agents`, `~/.claude` and
`~/.codex` stay real directories, and only the individual files above become
symlinks.
Without it, stow would symlink the whole directory on a fresh machine, and all
session history, caches and credentials would end up inside this repo.

## Not tracked

- `~/.claude.json`, `~/.claude/*` (other than `CLAUDE.md`): runtime state,
  sessions, plugin cache.
- `~/.codex/config.toml`: the Codex app rewrites it with absolute paths,
  app versions and per-project trust levels, so it doesn't diff cleanly.
- `~/.codex/rules/default.rules`: one-off command approvals.
- `~/.codex/auth.json`, `~/.claude` credentials: secrets.

If you add a `~/.claude/settings.json` (permissions, hooks, status line) or
custom commands/agents/skills, move them to `dot-claude/` and restow.
