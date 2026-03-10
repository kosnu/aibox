---
name: link-personal-skills
summary: Link repository skills into ~/.copilot/skills as personal skills.
---

Use this skill when the user asks to make repository skills available as personal skills via symlink.

## Command

```bash
.github/skills/link-personal-skills/scripts/link_personal_skills.sh
```

## Behavior
- Ensures `~/.copilot/skills` exists.
- For each directory in `.github/skills`, creates or updates `~/.copilot/skills/<skill-name>` symlink.
- Prints linked skill names and target paths.
