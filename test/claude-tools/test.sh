#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "claude on PATH" command -v claude
check "claude is per-user symlink" test -L "$HOME/.local/bin/claude"
check "claude runs"    claude --version
check "bun on PATH"    command -v bun
check "bun runs"       bun --version
check "opus wrapper"   test -x /usr/local/bin/opus
check "fable wrapper"  test -x /usr/local/bin/fable
check "agents wrapper" test -x /usr/local/bin/agents

reportResults
