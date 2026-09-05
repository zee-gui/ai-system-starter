---
title: Frontmatter Spec
type: moc
status: evergreen
created: 2026-09-05
updated: 2026-09-05
tags: [system, meta]
related: ["[[conventions]]"]
---

# Frontmatter Spec

Every note carries this YAML block. Consistency is what makes the vault queryable (Obsidian search,
Dataview, AI assistants).

## Canonical schema

```yaml
---
title: <human-readable title>
type: project|client|technology|business|learning|idea|research|career|life|resource|moc|reference|spec|plan|log
status: seed|active|paused|done|evergreen|archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []          # broad facets, lowercase
related: []       # wikilinks, e.g. ["[[Next.js]]", "[[a-table]]"]
caps: []          # optional, the role(s) this note serves
---
```

## Field rules

| Field | Required | Notes |
|-------|----------|-------|
| `title` | yes | Human title; may differ from filename. |
| `type` | yes | One of the controlled values above. Drives templates and queries. |
| `status` | yes | `active`/`paused`/`done` for projects; `evergreen` for stable reference; `seed` for early ideas. |
| `created` | yes | ISO date, set once. |
| `updated` | yes | ISO date, bump on meaningful edits. |
| `tags` | no | Lowercase, controlled. Empty list is fine. |
| `related` | no | Wikilinks. The graph's backbone, fill it in. |
| `caps` | no | 0 to 3 roles, your own closed list, ordered by primacy. |

## `caps`, the role axis (optional)

A role (`cap`, short for casquette) is a hat you wear and where you have something to prove, not a
subject. Define your own small closed list, four to six values. Example for a solo founder:

| Value | What it is |
|---|---|
| `builder` | You build products. Lives in `1-Projects` and ideas. |
| `founder` | You run the business: commercial, ops, decisions. |
| `knowledge-os` | You build your own system of knowledge and agents. Lives in `4-Tools`. |

Keep it closed and small. A role with only one note is not a role. A note with no `caps` is normal
(life notes, essays). This is why `caps` is a field and not a folder.

## Optional type-specific fields
Add only where they earn their place:
- **project**: `repo`, `stack: []`, `client`, `url`, `started`, `language`
- **client**: `industry`, `location`, `engagement`
- **technology**: `category`, `homepage`
- **resource**: `source_url`, `author`

## Audit
`4-Tools/scripts/vault-audit.py` checks this schema, broken wikilinks, and duplicate basenames.
Run `python3 4-Tools/scripts/vault-audit.py --root .` from the vault root.
