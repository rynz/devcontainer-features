#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "claude on PATH" command -v claude
check "claude is per-user symlink" test -L "$HOME/.local/bin/claude"
check "claude runs"    claude --version
check "bun on PATH"    command -v bun
check "bun runs"       bun --version
check "python3 on PATH" command -v python3
check "python alias"   python --version
check "pip runs"       python3 -m pip --version
check "venv works"     python3 -m venv /tmp/venv-check
check "opus wrapper"   test -x /usr/local/bin/opus
check "fable wrapper"  test -x /usr/local/bin/fable
check "agents wrapper" test -x /usr/local/bin/agents

reportResults
