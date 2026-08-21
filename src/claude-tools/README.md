# claude-tools

Installs the native [Claude Code](https://code.claude.com) binary (no Node.js required), [Bun](https://bun.sh), and three wrapper commands:

| Command  | Runs                                                               |
| -------- | ------------------------------------------------------------------ |
| `opus`   | `claude --permission-mode auto --model opus --effort xhigh`        |
| `fable`  | `claude --permission-mode auto --model fable --effort high`        |
| `agents` | `claude agents --permission-mode auto --model fable --effort high` |

## Usage

```json
"features": {
  "ghcr.io/rynz/devcontainer-features/claude-tools:1": {}
}
```

## Options

| Option            | Type    | Default  | Description                               |
| ----------------- | ------- | -------- | ----------------------------------------- |
| `installBun`      | boolean | `true`   | Install Bun to `/usr/local/bin`           |
| `claudeVersion`   | string  | `latest` | `latest`, `stable`, or a specific version |
| `installWrappers` | boolean | `true`   | Install `opus`, `fable`, `agents`         |

Claude is installed per-user (into `~/.local/share/claude`, symlinked from `~/.local/bin/claude`) so its built-in auto-updater keeps working; `/usr/local/bin/claude` is a shim that execs the per-user binary; the `claudeVersion` option only sets the starting version. Bun and the wrappers go to `/usr/local/bin`.

Per-user config (`~/.claude/settings.json`, `gh` auth, etc.) is out of scope — do that in `postCreateCommand`.
