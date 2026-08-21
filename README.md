# devcontainer-features

Dev Container Features published to `ghcr.io/rynz/devcontainer-features`.

| Feature | Description |
| --- | --- |
| [claude-tools](./src/claude-tools) | Native Claude Code binary, Bun, and `opus`/`fable`/`agents` wrappers |

## Local test

```sh
npm i -g @devcontainers/cli
devcontainer features test --features claude-tools --base-image mcr.microsoft.com/devcontainers/base:ubuntu-24.04 .
```

## Publishing

Pushing changes under `src/` to `main` runs `release.yml`, which publishes to GHCR via `devcontainers/action`. A newly added feature is published as a private package; flip it to public in its GitHub package settings before referencing it from a `devcontainer.json`.

## Releasing a new version

`devcontainers/action` only publishes when the `version` in `src/<feature>/devcontainer-feature.json` is new — bump it (semver) in the same PR as the change, or the push to `main` is a no-op for GHCR.

## License

[MIT](./LICENSE)
