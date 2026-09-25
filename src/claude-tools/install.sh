#!/usr/bin/env bash
# Runs as root at image build time. Option values arrive as upper-cased env vars.
# The devcontainer CLI also provides _REMOTE_USER / _REMOTE_USER_HOME.
set -euo pipefail

INSTALLBUN="${INSTALLBUN:-true}"
CLAUDEVERSION="${CLAUDEVERSION:-latest}"
INSTALLWRAPPERS="${INSTALLWRAPPERS:-true}"
INSTALLPYTHON="${INSTALLPYTHON:-true}"

USERNAME="${_REMOTE_USER:-root}"
USER_HOME="${_REMOTE_USER_HOME:-$(getent passwd "$USERNAME" | cut -d: -f6)}"

export DEBIAN_FRONTEND=noninteractive
if ! command -v curl >/dev/null || ! command -v unzip >/dev/null; then
  apt-get update
  apt-get install -y --no-install-recommends ca-certificates curl unzip
  rm -rf /var/lib/apt/lists/*
fi

if [ "$INSTALLPYTHON" = "true" ]; then
  echo "==> Installing python (system-wide)"
  # python-is-python3 provides the bare `python` command.
  apt-get update
  apt-get install -y --no-install-recommends python3 python3-pip python3-venv python-is-python3
  rm -rf /var/lib/apt/lists/*
fi

if [ "$INSTALLBUN" = "true" ]; then
  echo "==> Installing bun (system-wide)"
  curl -fsSL https://bun.com/install | BUN_INSTALL=/usr/local bash
  chmod 755 /usr/local/bin/bun
fi

echo "==> Installing claude ($CLAUDEVERSION) for $USERNAME"
# Installed per-user so Claude's built-in auto-updater keeps working:
# binaries live in ~/.local/share/claude/versions, ~/.local/bin/claude is a symlink.
# A shim at /usr/local/bin/claude execs the per-user binary so no PATH change is needed.
USER_GROUP="$(id -gn "$USERNAME")"
# Create ~/.local owned by the user up front; the installer (run as that user) needs to write there.
install -d -o "$USERNAME" -g "$USER_GROUP" "$USER_HOME/.local" "$USER_HOME/.local/bin" "$USER_HOME/.local/share"
if [ "$USERNAME" = "root" ]; then
  curl -fsSL https://claude.ai/install.sh | bash -s -- "$CLAUDEVERSION"
else
  su - "$USERNAME" -c "curl -fsSL https://claude.ai/install.sh | bash -s -- '$CLAUDEVERSION'"
fi

cat > /usr/local/bin/claude <<'SHIM'
#!/usr/bin/env bash
# claude-tools shim: run the per-user, self-updating Claude install.
real="$HOME/.local/bin/claude"
if [ ! -x "$real" ]; then
  echo "claude is not installed for $(id -un); run: curl -fsSL https://claude.ai/install.sh | bash" >&2
  exit 127
fi
exec "$real" "$@"
SHIM
chmod 755 /usr/local/bin/claude

if [ "$INSTALLWRAPPERS" = "true" ]; then
  echo "==> Installing wrappers"
  install -m 755 "$(dirname "$0")"/bin/* /usr/local/bin/
fi

echo "==> claude-tools done"
