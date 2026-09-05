# Choosing models (free first)

The system is model-agnostic. You rent a model; you own your context. This kit defaults to free
models on **b.ai**, an OpenAI-compatible aggregator, and you can swap at any time with `/models`.

## The default free stack
- **`bai/qwen3.8-flash`** : default. Good all-rounder, supports tool calls, free tier.
- **`bai/glm-5.3-flash`** : fallback. Free tier.
- **`bai/deepseek-v4-flash`** : listed, discounted (not always free).

Each person creates their **own** free b.ai key at https://chat.b.ai and pastes it once during
install via `opencode auth login`. Keys are never shared and never written into a config file in
plaintext (they live in `~/.local/share/opencode/auth.json`).

> The free list rotates. Before relying on a model, check the current `(free)` models at chat.b.ai.
> Read the source, do not assume.

## Honest expectations
These free models have **small context windows** (roughly 32k to 64k tokens). That is fine for this
system because the vault feeds context in small pieces. To stay inside the window:
- Read snippets, not whole files.
- One task per turn.
- Keep output terse.
- For a genuinely hard reasoning step, switch to a stronger model for that turn, then switch back.

## Other providers (optional)
- **OpenRouter** free tier: model `qwen/qwen3-coder:free`, base URL `https://openrouter.ai/api/v1`.
  A good offline-of-b.ai backup. Rate limited (about 20 requests/min, roughly 50/day, more after a
  one-time small credit purchase).
- **z.ai / GLM Coding Plan** (paid, cheap): if you later want more headroom, roughly 3 to 30 a month.
- **Ollama** (local, free, offline): slower with a heavy harness, best for background or private
  tasks. `ollama pull qwen2.5-coder:7b`.

To add any of these, add a `provider` block to `~/.config/opencode/opencode.json` the same way the
`bai` block is written. Any OpenAI-compatible endpoint plugs in via `@ai-sdk/openai-compatible`.
