Respond to the user in Japanese.

## Repository Context

- `.agents/skills/` contains shared Codex skills. `.codex/AGENTS.override.md` contains personal defaults installed into Codex home; keep repository-specific guidance here instead.
- Home entries can be symlinks to this checkout, so edits to shared instructions may affect other sessions before a commit. Inspect link targets when the delivery scope matters.
- `scripts/setup-codex.sh` changes home entries. Run it only for a requested setup or relink; use `bash scripts/test-setup-codex.sh` for setup regression checks in a disposable home.
- For skill edits, check invocation boundaries, linked references, and representative decision cases. A format check alone does not establish behavioral quality. Run setup regression checks when changing installation behavior.
