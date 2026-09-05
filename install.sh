#!/usr/bin/env bash
#
# install.sh - installeur guide du systeme IA personnel (OpenCode + modeles gratuits + vault).
#
# Idempotent. Sauvegarde tout fichier qu'il remplace (.bak-<horodatage>).
#   Usage:
#     bash install.sh            # install interactive
#     bash install.sh --check    # dry-run : dit ce qu'il ferait, ne modifie rien
#
set -euo pipefail

CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OPENCODE_DIR="$HOME/.config/opencode"
VAULT="$HOME/Vault"

say()  { printf '%s\n' "$*"; }
step() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
ask()  { # ask "question" -> reponse dans $REPLY_VAL ; en --check renvoie vide
  if [ "$CHECK" = 1 ]; then REPLY_VAL=""; return; fi
  printf '%s ' "$*"; IFS= read -r REPLY_VAL || REPLY_VAL=""
}
yes_no() { # yes_no "question" -> 0 si oui
  if [ "$CHECK" = 1 ]; then say "  [check] demanderait : $* (par defaut non)"; return 1; fi
  printf '%s [o/N] ' "$*"; IFS= read -r a || a=""; [ "$a" = "o" ] || [ "$a" = "O" ] || [ "$a" = "y" ]
}
backup() { # backup <fichier>
  [ -e "$1" ] || return 0
  if [ "$CHECK" = 1 ]; then say "  [check] sauvegarderait $1"; return; fi
  cp "$1" "$1.bak-$STAMP" && say "  sauvegarde : $1.bak-$STAMP"
}
install_file() { # install_file <source> <dest>
  local src="$1" dst="$2"
  if [ "$CHECK" = 1 ]; then say "  [check] copierait $src -> $dst"; return; fi
  mkdir -p "$(dirname "$dst")"; backup "$dst"; cp "$src" "$dst"; say "  installe : $dst"
}

say "Systeme IA personnel - installeur"
[ "$CHECK" = 1 ] && say "(mode --check : rien ne sera modifie)"

# 1. Preflight ----------------------------------------------------------------
step "1/8  Verification de l'environnement"
[ "$(uname)" = "Darwin" ] || say "  attention : concu pour macOS, la suite peut varier."
for bin in git curl; do
  command -v "$bin" >/dev/null 2>&1 && say "  ok : $bin" || say "  MANQUE : $bin (installe-le avant de continuer)"
done
command -v node >/dev/null 2>&1 && say "  ok : node ($(node -v))" || say "  info : node absent (utile pour les serveurs MCP, pas bloquant)"

# 2. OpenCode -----------------------------------------------------------------
step "2/8  OpenCode"
if command -v opencode >/dev/null 2>&1; then
  say "  deja installe : $(opencode --version 2>/dev/null || echo present)"
else
  if [ "$CHECK" = 1 ]; then
    say "  [check] installerait OpenCode : curl -fsSL https://opencode.ai/install | bash"
  elif yes_no "  OpenCode n'est pas installe. L'installer maintenant ?"; then
    curl -fsSL https://opencode.ai/install | bash
  else
    say "  saute. Installe-le ensuite : curl -fsSL https://opencode.ai/install | bash"
  fi
fi

# 3. Auth b.ai ----------------------------------------------------------------
step "3/8  Cle du fournisseur de modeles (b.ai, gratuit)"
say "  Cree ta cle gratuite sur https://chat.b.ai puis colle-la a l'invite d'OpenCode."
say "  Elle est stockee dans ~/.local/share/opencode/auth.json, jamais en clair dans un fichier de config."
if [ "$CHECK" = 1 ]; then
  say "  [check] lancerait : opencode auth login  (provider: bai, baseURL https://api.b.ai/v1)"
elif command -v opencode >/dev/null 2>&1 && yes_no "  Lancer 'opencode auth login' maintenant ?"; then
  opencode auth login || say "  (tu pourras relancer 'opencode auth login' plus tard)"
else
  say "  saute. Plus tard : opencode auth login"
fi

# 4. Config OpenCode ----------------------------------------------------------
step "4/8  Config OpenCode (MCP + provider bai, defaut qwen3.8-flash)"
install_file "$SCRIPT_DIR/opencode/opencode.json" "$OPENCODE_DIR/opencode.json"
install_file "$SCRIPT_DIR/opencode/AGENTS.md"     "$OPENCODE_DIR/AGENTS.md"

# 5. AGENTS.md maison ---------------------------------------------------------
step "5/8  Regles globales (~/AGENTS.md)"
install_file "$SCRIPT_DIR/AGENTS.md" "$HOME/AGENTS.md"

# 6. Vault --------------------------------------------------------------------
step "6/8  Vault (second cerveau)"
if [ -d "$VAULT" ]; then
  say "  ~/Vault existe deja, on n'y touche pas."
elif [ "$CHECK" = 1 ]; then
  say "  [check] copierait vault-skeleton -> ~/Vault, puis git init + premier commit"
else
  cp -R "$SCRIPT_DIR/vault-skeleton" "$VAULT"
  ( cd "$VAULT" && git init -q && git add -A && git commit -q -m "Init vault from starter skeleton" )
  say "  cree : ~/Vault (git initialise, premier commit fait)"
  say "  Ouvre-le dans Obsidian, et commence par 0-Home/Me.md."
fi

# 7. Skills + commands --------------------------------------------------------
step "7/8  Skills et commandes OpenCode"
if [ "$CHECK" = 1 ]; then
  say "  [check] copierait skills/ -> $OPENCODE_DIR/skills/ et commands/ -> $OPENCODE_DIR/commands/"
else
  mkdir -p "$OPENCODE_DIR/skills" "$OPENCODE_DIR/commands"
  cp -R "$SCRIPT_DIR/skills/." "$OPENCODE_DIR/skills/"
  cp -R "$SCRIPT_DIR/commands/." "$OPENCODE_DIR/commands/"
  say "  installes : skills (humanizer, new-project, vault-enrich, weekly-review), commandes (/initialisation, /import-context, /weekly-review)"
fi

# 8. Vault d'entreprise (optionnel) -------------------------------------------
step "8/8  Vault d'entreprise partage (optionnel)"
ask "  URL du depot git du vault d'equipe (vide pour sauter) :"
TEAM_URL="$REPLY_VAL"
if [ -n "$TEAM_URL" ]; then
  ask "  Nom local du dossier (defaut: Vault-team) :"; TEAM_DIR="${REPLY_VAL:-Vault-team}"
  if [ "$CHECK" = 1 ]; then
    say "  [check] clonerait $TEAM_URL -> ~/$TEAM_DIR"
  else
    git clone "$TEAM_URL" "$HOME/$TEAM_DIR" && say "  clone : ~/$TEAM_DIR"
    printf '\n- `~/%s` : vault d'\''equipe partage (contexte et memoire de l'\''organisation).\n' "$TEAM_DIR" >> "$HOME/AGENTS.md"
    say "  pointeur ajoute a ~/AGENTS.md"
  fi
else
  say "  saute (tu pourras cloner le vault d'equipe plus tard)."
fi

# Fin -------------------------------------------------------------------------
step "Termine"
cat <<'EOF'
Prochaines 90 minutes (pour basculer du chatbot au vrai systeme) :
  1. Ouvre ~/Vault dans Obsidian.
  2. Remplis 0-Home/Me.md (qui tu es, ce que tu veux, comment tu bosses).
  3. Liste tes projets actifs dans 1-Projects/ (un par note).
  4. Liste tes roles (caps) dans Me.md.
  5. Repere une tache recurrente a transformer en skill.

Lance OpenCode dans un dossier, puis essaie la commande /initialisation.
Modeles et alternatives : docs/choosing-models.md.
EOF
