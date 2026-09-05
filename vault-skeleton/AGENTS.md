# Vault contract (for AI agents)

This vault is a second brain: a human-first, git-versioned knowledge base. An AI agent reads it for
context and enriches it, but never owns it. If the AI disappeared tomorrow, the vault would still be
a usable set of notes for a human.

## Prime directives
1. **Human first.** The vault is usable without any AI. AI enhances it; AI is never the system.
2. **Golden Rule.** Every note answers at least one future question. If it does not, do not create it.
3. **Single source of truth.** Search before writing. If a note already covers it, update that note.
   Link with `[[wikilinks]]`, never duplicate content.
4. **Atomic notes.** One concept per note.

## Before you write a note
- Search the vault first (`rg -i "<concept>" . --glob '*.md'`, or your search tool).
- Pick the folder with one question: does it have an end and a deliverable?
  Yes then `1-Projects`. No then `3-Garden/<sub>`. System and tooling then `4-Tools`.
  Identity and maps then `0-Home`. Raw capture then `0-Inbox`.
- Start from a template in `4-Tools/templates/`.
- Fill the frontmatter per `4-Tools/frontmatter-spec.md`.
- Add `[[wikilinks]]` to related notes and register it in the matching `0-Home/*-MOC.md`.

## Never
- Never copy real secrets into a note (API keys, tokens, bank details, 2FA). Status and metadata
  only. Secrets live in the macOS Keychain.
- Never restructure the vault for the AI's convenience. The folder model is deliberate.

## Committing
- Commit only the paths you touched. In a solo vault, plain `git add -A && git commit && git push`
  is fine. In a shared vault where more than one person or session may write at once, commit named
  paths only, never `git add -A`.
