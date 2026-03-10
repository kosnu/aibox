---
name: setup-codex-home
description: Links repository .codex entries into ~/.codex with symlinks. Use when the user asks to place .codex in the home directory, create symlinks for Codex settings, or sync this repo's .codex into the user directory.
---

# Setup Codex Home

## Steps

1. Confirm the repository contains the source `.codex` directory.
2. Run `bash scripts/setup-codex.sh` from the repository root.
3. Report the linked entries and any backups created under `~/.codex`.

## Behavior

- Link each direct child of repository `.codex` into `~/.codex`.
- Keep `~/.codex` itself as a real directory; do not replace it with a single symlink.
- If the target already points to the correct source, skip it.
- If a conflicting file, directory, or symlink exists, move it to `${target}.bak` before linking.

## Next Action

Suggest verifying with `ls -la ~/.codex`.
