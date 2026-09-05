# Home map and global rules

This file is the front door for any AI agent working on this machine. It is read first, every
session, by OpenCode (and by Claude Code, Codex, or Gemini CLI if you use them too). It is written
for a human first: you should understand your own system without an AI.

## The system in one line
Result = Model x Context x Tools. The model is rented and swappable. The context is yours and lives
in `~/Vault`. This file plus the Vault is that context.

## Folder map
- `~/Vault` : your second brain (Obsidian + git). Canonical knowledge. Read before re-deriving.
- `~/Vault-<team>` : the shared org vault, if you are on a team (peer-owned, both push to it).
- `~/projects` : code projects, one folder each, English kebab-case names.
- `~/.config/opencode` : your OpenCode config, skills, commands, agents.

## Sensitive zones (never read, never transmit)
- Anything under `~/Documents` or a folder named `*SECRETS*`.
- Real secrets go in the macOS Keychain, referenced from `~/.zshrc`, never pasted into a note or a
  config file.

## Hard rules
1. **No AI attribution.** Anything that goes out under your name (git commits, PR descriptions,
   issues, messages to other people) is signed by you alone. No "Generated with", no
   "Co-Authored-By: an AI", no "written by AI" note.
2. **No em dash or en dash in prose written as you** (`—`, `–`, and their HTML entities). Use a
   period, comma, colon, or parentheses. This is an anti-AI-tell rule; see the `humanizer` skill.
3. **English names** for every folder and file you create or rename.
4. **Vault is source of truth.** Search it before writing something new; link, do not duplicate.
   Enrich it with atomic notes per `~/Vault/AGENTS.md`.
5. **Small-context discipline** (the free models are small): read snippets not whole files, keep
   output terse, one task at a time.

## Tooling
- Search: prefer a fast code search over reading whole trees.
- Docs: read the authoritative source before asserting how a tool or API works. Do not invent.
- Git: commit only the paths you mean to; do not `git add -A` if other agents or sessions may be
  writing the same repo at the same time.
