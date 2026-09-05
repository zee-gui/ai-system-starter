# Du bonus IPCRA a la pratique (cinq dossiers)

Le bonus de formation propose une structure a huit dossiers (Inbox, Projets, Casquettes, Garden,
Tools, Ressources, Archive, Dynamique). Ce kit en garde cinq. Ce n'est pas un raccourci : c'est le
meme systeme, avec trois axes sortis des dossiers pour eviter que le meme concept laisse des debris
dans plusieurs endroits.

## La correspondance

| Bonus (8 dossiers) | Ici | Pourquoi |
|---|---|---|
| `00 Inbox` | `0-Inbox` | Identique. Capture qui se vide. |
| `01 Projets` | `1-Projects` | Identique. A une fin et un livrable. |
| `02 Casquettes` | champ `caps:` | Une casquette est un role, pas un lieu. Elle devient un champ de frontmatter, donc une note peut servir deux casquettes sans etre dupliquee. |
| `03 Garden` | `3-Garden` | Identique. Ce qui murit. |
| `04 Tools` | `4-Tools` | Identique. Le manuel d'operation. |
| `05 Ressources` | `3-Garden/resources` | Une ressource est du jardin qui n'a pas encore de projet. Un sous-dossier suffit. |
| `06 Archive` | champ `status:` | Archiver = `status: archived` ou `done`. Pas de deplacement, donc pas de lien casse ni de concept eparpille. |
| `07 Dynamique` | hors vault | Les donnees qui bougent (clients, KPI, factures) vont dans une base adaptee, pas dans des notes markdown. Le vault tient le contexte statique. |

## Le principe

Le dossier porte **une seule chose** : la provenance et la finalite. Tout le reste (cycle de vie,
role, domaine) est du frontmatter. C'est ce qui permet de repondre a la seule question de rangement,
"est-ce que ca a une fin et un livrable ?", sans jamais hesiter entre deux dossiers.

## Les commandes du bonus

Le bonus liste des commandes utiles (`/initialisation`, `/import-context`, `/weekly-review`,
`/create-skill`, `/prepare-meeting`, `/review-kpi`). Ce kit en livre trois, celles qui ont le plus
de valeur au demarrage, dans `commands/`. Les autres se creent au fur et a mesure : une commande
n'a de valeur que si elle encapsule ta methode, pas une methode generique.
