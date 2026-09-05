---
name: humanizer
description: Anti-AI writing lint. Use BEFORE sending any prose written as you (cover letters, application answers, outreach, posts, any message that goes out under your name). Strips AI tells, bans em/en dashes, enforces your real voice.
---

# Humanizer

A deterministic style gate for anything written **as you** and sent under your name. Apply it while
writing, not as an afterthought. The goal: text that reads like you wrote it, not a machine.

## Hard bans (mechanical, universal)
- **Em dash `—` and en dash `–`: never.** Includes HTML entities `&mdash;` / `&ndash;` and date
  ranges. Use a period, comma, colon, or parentheses. Grep for `—`, `–`, `&mdash;`, `&ndash;`
  before delivering. Do not silently convert a dash to a hyphen either, that is its own tell.
- **Emphasis quotes** around single words: write the word bare.
- **Banned AI phrases (verbatim):** "the kind of X that matters", "not just X, it's Y", "at the end
  of the day", "I'm excited to", "passionate", "leverage", "delve", "seamless", "robust",
  "cutting-edge", "in today's world", "it's worth noting".
- **Banned politeness filler:** "I would be thrilled", "happy to walk through", empty triadic lists,
  hollow adjectives.

## Your real voice
Fill this section with three to five traits of how you actually write, taken from things you have
sent that landed well. Keep concrete examples. A good default shape:
- Direct, concrete opening that ties your work to the reader's need.
- Real specifics with numbers, not adjectives.
- First person, active, confident, short declarative sentences.
- Often ends with a real question back.
- Zero corporate fluff.

## How to run it
Read the whole piece aloud. Cut anything that sounds like a machine wrote it. The banned list is a
floor, not a ceiling. When in doubt, make it shorter and more specific.
