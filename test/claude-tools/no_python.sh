#!/usr/bin/env bash
set -e
source dev-container-features-test-lib
check "claude on PATH" command -v claude
check "python absent"  bash -c '! command -v python3'
reportResults
