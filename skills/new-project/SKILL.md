---
name: new-project
description: Use when starting a new code project. Scaffolds ~/projects/<name>/ with your conventions (local AGENTS.md, README, git), ASKS for the stack each time, then registers it in the vault (1-Projects + Projects-MOC).
---

# new-project, scaffold and register a new project

Create a new project under `~/projects/` and wire it into the vault so it is discoverable.

## Checklist (do in order)
1. **Name.** Take `<name>` (kebab-case, English). If `~/projects/<name>/` already exists, stop
   (no overwrite).
2. **Ask the stack, every time (no default).** One compact question: language/framework, DB/backend,
   payments if relevant. Wait for the answer.
3. **Scaffold `~/projects/<name>/`:**
   - `git init`
   - `README.md` (name, one-line purpose, stack)
   - local `AGENTS.md`, short, pointing to `~/AGENTS.md` for the home map and stating the project's
     stack plus any project-specific rules
   - `.gitignore` appropriate to the stack
4. **Register in the vault (`~/Vault`):**
   - Create `1-Projects/<name>.md` from `4-Tools/templates/project.md`, frontmatter
     `type: project, status: active, created/updated: today`, plus optional
     `repo, stack: [...], language, url`.
   - Add a bullet to `~/Vault/0-Home/Projects-MOC.md`.
5. **Commit the vault** (one atomic commit).
6. Report the created paths and the registered note.

## Notes
- Do not scaffold framework boilerplate unless asked. Keep the skeleton minimal; the user can run
  the framework's own init (`create-next-app`, `create vite`) after.
- English naming throughout. Respect `~/AGENTS.md`.
