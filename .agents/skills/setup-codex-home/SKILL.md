---
name: setup-codex-home
description: Sync repository .codex entries and .agents skills into the user's home directories with file-level symlinks while preserving a home-local config.toml. Use when the user asks to set up, relink, or verify this repository's Codex home configuration.
---

# Setup Codex Home

## Success Criteria

Finish only after the repository entries are synchronized, stale managed links are removed, home config remains local, and the resulting link targets are verified.

## Steps

1. Confirm the repository contains the source `.codex` directory.
2. Run `bash scripts/setup-codex.sh` from the repository root.
3. Verify `~/.codex` and `~/.agents/skills` are real directories, not directory-level symlinks.
4. Verify `~/.codex/config.toml` exists as a regular home-local file and is not a symlink.
5. Compare source children with their managed home entries and verify every expected symlink resolves to the repository source.
6. Confirm no stale managed symlink remains for a source child that no longer exists.
7. Report linked, skipped, unlinked, restored, copied, and backed-up entries from the setup output. Stop with the exact failed condition if verification does not pass.

## Behavior

- Link root files and file-level children from repository `.codex` into `~/.codex`, except `config.toml` and `skills`.
- Keep `~/.codex` itself as a real directory; do not replace it with a single symlink.
- Keep `~/.codex/config.toml` as a home-local config. If it is an old symlink to the repository config, remove that link and restore `~/.codex/config.toml.bak` when present.
- Keep `~/.agents/skills` as a real directory and link each repository `.agents/skills` child individually.
- If the target already points to the correct source, skip it.
- If a conflicting file, directory, or symlink exists, move it to `${target}.bak` before linking.
