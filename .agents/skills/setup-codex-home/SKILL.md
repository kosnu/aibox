---
name: setup-codex-home
description: Set up, relink, or verify this repository's Codex home symlinks when requested, preserving the home-local config.toml.
---

# Setup Codex Home

## Success Criteria

For setup or relinking, finish after repository entries are synchronized, stale managed links are removed, home config remains local, and link targets are verified. For verification-only requests, inspect these conditions and report discrepancies without running the setup script or changing files.

## Steps

1. Confirm the repository contains the source `.codex` directory.
2. For setup or relinking, run `bash scripts/setup-codex.sh` from the repository root.
3. Verify `~/.codex` and `~/.agents/skills` are real directories, not directory-level symlinks.
4. Verify `~/.codex/config.toml` exists as a regular home-local file and is not a symlink.
5. Compare source children with their managed home entries and verify every expected symlink resolves to the repository source.
6. Confirm no stale managed symlink remains for a source child that no longer exists.
7. Report discrepancies for verification-only requests; after setup, summarize linked, skipped, unlinked, restored, copied, and backed-up entries from its output. Report the exact failed condition if verification does not pass.

## Behavior

- Link repository `.codex` root file entries and direct children of its directories into matching home locations, except `config.toml` and `skills`.
- Keep each managed home directory as a real directory; link its direct child entries individually, whether a child is a file or directory.
- Keep `~/.codex` itself as a real directory; do not replace it with a single symlink.
- Keep `~/.codex/config.toml` as a home-local config. If it is an old symlink to the repository config, remove that link and restore `~/.codex/config.toml.bak` when present.
- Keep `~/.agents/skills` as a real directory and link each repository `.agents/skills` child individually.
- If the target already points to the correct source, skip it.
- If a conflicting file, directory, or symlink exists, move it to `${target}.bak` before linking.
