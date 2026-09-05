# Systeme IA personnel (starter)

Un espace souverain, organise autour de toi, dans lequel n'importe quel modele IA vient travailler
avec ton contexte, tes methodes et tes outils. Tu loues un modele, tu possedes ton contexte.

> Resultat = Modele x Contexte x Outils.
> Le modele est la puissance brute (loue, remplacable). Le contexte est la pertinence (le tien,
> dans `~/Vault`). Les outils sont la capacite d'agir (OpenCode). Ce kit installe les trois.

Il tourne sur **OpenCode** (agent de terminal open source) et des **modeles gratuits** (b.ai :
Qwen3.8 Flash, GLM 5.3 Flash). Zero dependance a un abonnement paye pour demarrer.

## Ce que tu obtiens

- **OpenCode** installe et cable sur un provider de modeles gratuits.
- **`~/Vault`** : ton second cerveau, une structure Obsidian a cinq dossiers, versionnee en git.
- **`~/AGENTS.md`** : les regles globales que tout agent lit en debut de session.
- **Des skills** (methodes reutilisables) et des **commandes** pour demarrer vite.

## Installation

```bash
git clone <url-de-ce-depot> ai-system-starter
cd ai-system-starter
bash install.sh --check   # voir ce qui serait fait, sans rien modifier
bash install.sh           # installer pour de vrai
```

L'installeur est idempotent et sauvegarde tout fichier qu'il remplace. Il te demandera de creer ta
propre cle gratuite sur https://chat.b.ai (chacun la sienne, jamais partagee).

## La structure du vault (cinq dossiers)

| Dossier | Role |
|---|---|
| `0-Home` | La porte d'entree : `Home`, `Me`, les cartes (MOC), les conventions. |
| `0-Inbox` | Capture brute qui se vide, jamais une source de verite. |
| `1-Projects` | Tout ce qui a une fin et un livrable. |
| `3-Garden` | Ce que tu ecris et qui murit (tech, idees, learning, business, career...). |
| `4-Tools` | Ton manuel d'operation : templates, scripts, skills. |

Une seule question de rangement : **est-ce que ca a une fin et un livrable ?** Oui alors
`1-Projects`. Non alors `3-Garden`. Le cycle de vie vit dans le champ `status`, jamais dans un
dossier. Detail : `vault-skeleton/4-Tools/conventions.md`.

> Ce modele est une version durcie de l'IPCRA du bonus de formation. La correspondance
> (Casquettes vers `caps:`, Ressources vers `3-Garden/resources`, Archive vers `status`) est dans
> `docs/` et les conventions.

## Les premieres 90 minutes

Ne commence pas par tout automatiser. Commence par un contexte propre.
1. Ouvre `~/Vault` dans Obsidian.
2. Remplis `0-Home/Me.md` : qui tu es, ce que tu veux, comment tu bosses.
3. Liste tes projets actifs dans `1-Projects/`.
4. Liste tes roles (`caps`) dans `Me.md`.
5. Repere une tache recurrente a transformer en skill.

Dans OpenCode, la commande `/initialisation` te fait passer cette interview.

## Changer de modele

Le defaut est `bai/qwen3.8-flash` (gratuit). Bascule avec `/models` dans OpenCode. Les modeles
gratuits ont un petit contexte : lis des extraits, garde des reponses courtes, une tache a la fois.
Alternatives (OpenRouter, z.ai, Ollama local) : `docs/choosing-models.md`.

## Vault d'entreprise (equipe)

Si tu travailles a plusieurs, l'installeur peut cloner un **vault d'equipe** partage : un depot git
co-detenu ou vous poussez tous les deux, pour mettre en commun le contexte et la memoire de
l'organisation. Rien de secret n'y va (les vrais secrets restent dans le Keychain). Ton vault perso
reste prive.

## Ce qui est deliberement exclu

Pas de hooks, pas de plugins, pas de machinerie propre a un seul agent. Le kit est **portable** :
la meme structure et les memes skills marchent sous OpenCode, Claude Code, Codex ou Gemini CLI,
parce que le contexte vit dans des fichiers markdown que tu possedes, pas dans une plateforme fermee.
