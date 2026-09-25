#!/usr/bin/env bash
# bun, claude and the opus/fable/agents wrappers come from the claude-tools feature.
set -euo pipefail

echo "==> Configuring Claude settings"
mkdir -p "$HOME/.claude"
bun -e '
  const fs = require("fs");
  const p = process.env.HOME + "/.claude/settings.json";
  const s = fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, "utf8")) : {};
  s.autoMemoryEnabled = false;
  s.enableArtifact = false;
  s.preferredNotifChannel = "terminal_bell";
  s.remoteControlAtStartup = false;
  s.switchModelsOnFlag = false;
  fs.writeFileSync(p, JSON.stringify(s, null, 2) + "\n");
'

echo "==> Configuring gh"
gh config set git_protocol ssh
if gh auth status >/dev/null 2>&1; then
  echo "    gh is authenticated"
else
  echo "    gh is NOT authenticated -- run: gh auth login"
fi

echo "==> Done"
