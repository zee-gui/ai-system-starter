---
name: vault-enrich
description: Use when a durable, reusable learning, decision, fix, or pattern emerges that belongs in your vault (~/Vault). Promotes it into ONE conforming atomic note (frontmatter, wikilinks, MOC registration) and commits.
---

# vault-enrich, promote knowledge into the vault

Turn a durable learning into a single atomic note in `~/Vault`, following the vault's own contract
(`~/Vault/AGENTS.md`, `4-Tools/conventions.md`, `4-Tools/frontmatter-spec.md`). Human-first,
source-of-truth, atomic. Do not dump session chatter, only durable reusable knowledge.

## Checklist (do in order)
1. **Golden Rule gate.** Does this note answer at least one future question? If not, stop and say so.
2. **Search first (anti-duplicate).** Search the vault for the concept
   (`rg -i "<concept>" ~/Vault --glob '*.md'`). If a note already covers it, update that note
   (bump `updated`, add to it). Link, do not repeat.
3. **Pick the folder** with the routing question from `4-Tools/conventions.md`: has an end and a
   deliverable then `1-Projects`; else `3-Garden/<sub>` (`tech`, `learning`, `ideas`, `research`,
   `business`, `career`, `resources`); system and tooling then `4-Tools`; identity and maps then
   `0-Home`. Five folders, no `Archive` (lifecycle lives in `status`).
4. **Start from the template** in `~/Vault/4-Tools/templates/` for that type.
5. **Frontmatter** per `frontmatter-spec.md`: `title, type, status, created (today),
   updated (today), tags, related [[...]]`. Filename = the concept in Title Case.
6. **Write atomically**, one concept. Add `[[wikilinks]]` to related notes.
7. **Register in the right MOC** in `~/Vault/0-Home/*-MOC.md`.
8. **Never copy secrets** into the vault (IDs, bank details, 2FA, raw financials). Metadata only.
9. **Commit** (one atomic commit).

## Notes
- Today's date comes from the environment; convert relative dates to absolute.
- If unsure which folder or type, ask one short question rather than guessing.
