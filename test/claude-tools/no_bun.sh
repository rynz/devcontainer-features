#!/usr/bin/env bash
set -e
source dev-container-features-test-lib
check "claude on PATH" command -v claude
check "bun absent"     bash -c '! command -v bun'
reportResults
