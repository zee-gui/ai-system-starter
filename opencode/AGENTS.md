# Global rules (OpenCode)

These rules load in every OpenCode session. Keep them short. Project-specific rules go in each
repo's own `AGENTS.md`.

## Where things live
- Read `~/AGENTS.md` first: it is the home map (folders, sensitive zones, tooling).
- `~/Vault` is your canonical knowledge base (Obsidian + git). Read it before re-deriving context;
  enrich it with atomic notes per `~/Vault/AGENTS.md`, then commit.
- If a shared team vault is wired (`~/Vault-<team>`), org-level context and decisions live there,
  your personal vault stays private.

## Safety
- Never read or transmit secrets. Real secrets (API keys, tokens, bank details) live in the macOS
  Keychain, never in a config file or a note.
- Folders and files you create or rename: English names.

## Working with small free models
The default models here (Qwen3.8 Flash, GLM 5.3 Flash on b.ai) have small context windows
(roughly 32k to 64k tokens). So:
- Read snippets, not whole files.
- Keep output terse.
- One task at a time; do not load ten files "just in case".
- For a hard reasoning task, switch to a stronger model for that turn (`/models`), then switch back.
