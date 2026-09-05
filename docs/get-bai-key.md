# Obtenir ta cle b.ai (gratuite)

b.ai est un agregateur de modeles compatible OpenAI. Il a un tier gratuit (Qwen3.8 Flash,
GLM 5.3 Flash). Chacun cree SA propre cle : elle t'identifie, elle ne se partage pas.

## Etapes
1. Va sur **https://chat.b.ai** et cree un compte (gratuit).
2. Dans les reglages du compte, cherche la section **API Keys** (parfois "Cles API" ou "Developer").
   Si tu ne la trouves pas, la doc officielle indique ou : **https://docs.b.ai**.
3. Cree une nouvelle cle et **copie-la** (elle commence en general par `sk-`). Tu ne la reverras
   peut-etre plus apres, garde-la le temps de l'etape suivante.
4. Dans le terminal, lance :
   ```bash
   opencode auth login
   ```
   Choisis le provider **bai** (ou "OpenAI compatible" avec l'URL `https://api.b.ai/v1`) et colle ta
   cle. Elle est stockee dans `~/.local/share/opencode/auth.json`, jamais en clair dans la config.

## Verifier que ca marche
Lance `opencode`, pose une question simple. Le modele par defaut est `bai/qwen3.8-flash`. Si tu veux
en changer, tape `/models`.

## Important
- Ne colle jamais ta cle dans un fichier du vault ou du depot. Elle vit uniquement dans
  `auth.json` (gere par OpenCode).
- Le tier gratuit tourne : si un modele n'est plus marque `(free)` sur chat.b.ai, prends-en un autre
  de la liste gratuite. Details et alternatives (OpenRouter, Ollama) : `choosing-models.md`.
