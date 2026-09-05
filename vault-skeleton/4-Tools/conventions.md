---
title: Conventions
type: moc
status: evergreen
created: 2026-09-05
updated: 2026-09-05
tags: [system, meta]
related: ["[[frontmatter-spec]]"]
---

# Conventions

The rules that make this vault a system rather than a pile of notes. Read before contributing.

## Core principles

### 1. Atomic notes, one concept = one note
A note is atomic when you cannot split it without one half becoming a separate idea you would want
to link to on its own. Prefer `React Server Components` over `React Tricks`.

### 2. Source of truth, every fact exists once
Never duplicate content. Link to the existing note and update the original. If you are tempted to
paste, you want a `[[wikilink]]`.

### 3. Human first
The vault must be fully usable without AI. AI enhances the system; AI is never the system.

### 4. Knowledge, not documentation
Capture decisions, learnings, discoveries, reusable solutions, business knowledge. Do not capture
temporary thoughts, random snippets, or disposable information.

## The Golden Rule
Every note should answer at least one future question. If not, delete it or do not create it.

## Placement, one question
The folder carries one thing only: provenance and purpose. The only placement question is:
**does it have an end and a deliverable?**
- Yes then `1-Projects`.
- No then `3-Garden/<sub>` (`tech`, `learning`, `ideas`, `research`, `business`, `career`,
  `resources`).
- System and tooling then `4-Tools`. Identity and maps then `0-Home`. Raw capture then `0-Inbox`.

Those five top-level folders are all there is. There is no `Archive` folder: **lifecycle lives in
`status`, never in the path.** An idea that becomes a project does not move; it goes
`seed` then `active` then `done`. This is what stops one concept leaving debris in three folders.

## The three off-folder axes
The folder is provenance. Everything else is frontmatter.

| Axis | Where it lives | Vocabulary |
|---|---|---|
| Lifecycle | `status` | `seed, active, paused, done, evergreen, archived` |
| Role (optional) | `caps` | your own closed list of roles you hold (see frontmatter-spec) |
| Domain | `tags` | broad facets, lowercase |

## Naming
- Filename = the concept, in Title Case (`Vector Databases.md`).
- Projects use their real repo name (`a-table.md`).
- MOCs end in `-MOC` (`Projects-MOC.md`).

## Linking
- Connect every new note to at least one existing note via `[[wikilinks]]`.
- Register it in its category MOC so it is reachable from `0-Home/Home`.
- Prefer links for specific relationships, tags for broad facets.
