#!/usr/bin/env bash
#
# install.sh - installeur guide du systeme IA personnel (OpenCode + modeles gratuits + vault).
# Pense pour un Mac neuf et quelqu'un qui debute : il installe les prerequis, configure
# l'auth GitHub, guide la cle de modeles, et met en place le vault.
#
# Idempotent. Sauvegarde tout fichier qu'il remplace (.bak-<horodatage>).
#   Usage:
#     bash install.sh            # install interactive
#     bash install.sh --check    # dry-run : dit ce qu'il ferait, ne modifie rien
#
set -uo pipefail

CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OPENCODE_DIR="$HOME/.config/opencode"
VAULT="$HOME/Vault"
AGENTS_MARK="# --- vault d'entreprise (ajoute par install.sh) ---"

say()  { printf '%s\n' "$*"; }
step() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
ask()  { if [ "$CHECK" = 1 ]; then REPLY_VAL=""; return; fi; printf '%s ' "$*"; IFS= read -r REPLY_VAL || REPLY_VAL=""; }
yes_no() {
  if [ "$CHECK" = 1 ]; then say "  [check] demanderait : $* (defaut non)"; return 1; fi
  printf '%s [o/N] ' "$*"; IFS= read -r a || a=""; [ "$a" = "o" ] || [ "$a" = "O" ] || [ "$a" = "y" ]
}
backup() { [ -e "$1" ] || return 0; if [ "$CHECK" = 1 ]; then say "  [check] sauvegarderait $1"; return; fi; cp "$1" "$1.bak-$STAMP" && say "  sauvegarde : $1.bak-$STAMP"; }
install_file() {
  local src="$1" dst="$2"
  if [ "$CHECK" = 1 ]; then say "  [check] copierait $src -> $dst"; return; fi
  mkdir -p "$(dirname "$dst")"; backup "$dst"; cp "$src" "$dst"; say "  installe : $dst"
}
have() { command -v "$1" >/dev/null 2>&1; }
brew_install() { # brew_install <formule> [--cask]
  if [ "$CHECK" = 1 ]; then say "  [check] brew install ${2:-} $1"; return; fi
  brew install ${2:-} "$1" && say "  installe : $1"
}

say "Systeme IA personnel - installeur"
[ "$CHECK" = 1 ] && say "(mode --check : rien ne sera modifie)"

# 1. Prerequis --------------------------------------------------------------
step "1/9  Prerequis (git, gh, node, Homebrew)"
[ "$(uname)" = "Darwin" ] || say "  attention : concu pour macOS."
if ! have brew; then
  say "  Homebrew absent. C'est le gestionnaire de paquets macOS, on en a besoin."
  if yes_no "  Installer Homebrew maintenant ?"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || true
  else
    say "  saute. Installe-le : https://brew.sh puis relance."
  fi
else
  say "  ok : Homebrew"
fi
have git || { say "  git absent"; yes_no "  Installer git ?" && brew_install git; }
have git && say "  ok : git"
have gh  || { say "  gh (GitHub CLI) absent"; yes_no "  Installer gh ?" && brew_install gh; }
have gh  && say "  ok : gh"
have node || { say "  node absent (utile pour les serveurs MCP)"; yes_no "  Installer node ?" && brew_install node; }
have node && say "  ok : node ($(node -v 2>/dev/null))"

# 2. OpenCode ---------------------------------------------------------------
step "2/9  OpenCode"
if have opencode; then say "  deja installe : $(opencode --version 2>/dev/null || echo present)"
elif [ "$CHECK" = 1 ]; then say "  [check] installerait OpenCode (curl opencode.ai/install | bash)"
elif yes_no "  Installer OpenCode ?"; then curl -fsSL https://opencode.ai/install | bash
else say "  saute. Plus tard : curl -fsSL https://opencode.ai/install | bash"; fi

# 3. Auth GitHub ------------------------------------------------------------
step "3/9  Connexion GitHub (pour cloner le vault d'entreprise prive)"
if [ "$CHECK" = 1 ]; then say "  [check] verifierait 'gh auth status', sinon 'gh auth login'"
elif have gh; then
  if gh auth status >/dev/null 2>&1; then say "  ok : deja connecte ($(gh api user --jq .login 2>/dev/null))"
  elif yes_no "  Te connecter a GitHub maintenant (gh auth login) ?"; then gh auth login
  else say "  saute. Le clone du vault d'entreprise echouera sans connexion."; fi
else say "  gh absent, saute (installe gh a l'etape 1 pour le clone prive)."; fi

# 4. Cle b.ai ---------------------------------------------------------------
step "4/9  Cle du fournisseur de modeles (b.ai, gratuit)"
say "  Comment obtenir ta cle gratuite : voir docs/get-bai-key.md (compte sur chat.b.ai, tu copies la cle)."
say "  Elle va dans ~/.local/share/opencode/auth.json, jamais en clair dans un fichier de config."
if [ "$CHECK" = 1 ]; then say "  [check] lancerait 'opencode auth login' (provider bai, https://api.b.ai/v1)"
elif have opencode && yes_no "  Lancer 'opencode auth login' maintenant ?"; then opencode auth login || say "  (relance 'opencode auth login' plus tard)"
else say "  saute. Plus tard : opencode auth login"; fi

# 5. Config OpenCode --------------------------------------------------------
step "5/9  Config OpenCode (MCP + provider bai, defaut qwen3.8-flash)"
install_file "$SCRIPT_DIR/opencode/opencode.json" "$OPENCODE_DIR/opencode.json"
install_file "$SCRIPT_DIR/opencode/AGENTS.md"     "$OPENCODE_DIR/AGENTS.md"

# 6. Regles globales --------------------------------------------------------
step "6/9  Regles globales (~/AGENTS.md)"
install_file "$SCRIPT_DIR/AGENTS.md" "$HOME/AGENTS.md"

# 7. Vault ------------------------------------------------------------------
step "7/9  Vault personnel (second cerveau)"
if [ -d "$VAULT" ]; then say "  ~/Vault existe deja, on n'y touche pas."
elif [ "$CHECK" = 1 ]; then say "  [check] copierait vault-skeleton -> ~/Vault + git init + premier commit"
else
  cp -R "$SCRIPT_DIR/vault-skeleton" "$VAULT"
  ( cd "$VAULT" && git init -q && git add -A && git commit -q -m "Init vault from starter skeleton" )
  say "  cree : ~/Vault (git initialise). Commence par 0-Home/Me.md."
fi

# 8. Obsidian ---------------------------------------------------------------
step "8/9  Obsidian (pour voir et editer le vault)"
if [ -d "/Applications/Obsidian.app" ]; then say "  ok : Obsidian deja installe."
elif [ "$CHECK" = 1 ]; then say "  [check] brew install --cask obsidian"
elif have brew && yes_no "  Installer Obsidian ?"; then brew_install obsidian --cask
else say "  saute. Installe-le : https://obsidian.md"; fi
say "  Dans Obsidian : 'Open folder as vault' sur ~/Vault (et sur ~/Vault-atable une fois clone)."

# 9. Skills, commandes, vault d'entreprise ----------------------------------
step "9/9  Skills, commandes, et vault d'entreprise"
if [ "$CHECK" = 1 ]; then say "  [check] copierait skills/ et commands/ dans $OPENCODE_DIR/"
else
  mkdir -p "$OPENCODE_DIR/skills" "$OPENCODE_DIR/commands"
  cp -R "$SCRIPT_DIR/skills/." "$OPENCODE_DIR/skills/"
  cp -R "$SCRIPT_DIR/commands/." "$OPENCODE_DIR/commands/"
  say "  installes : skills + commandes."
fi
ask "  Depot du vault d'entreprise (ex: zee-gui/vault, vide pour sauter) :"
TEAM_REPO="$REPLY_VAL"
if [ -n "$TEAM_REPO" ]; then
  ask "  Dossier local (defaut: Vault-atable) :"; TEAM_DIR="${REPLY_VAL:-Vault-atable}"
  if [ "$CHECK" = 1 ]; then say "  [check] gh repo clone $TEAM_REPO ~/$TEAM_DIR + pointeur idempotent dans ~/AGENTS.md"
  elif [ -d "$HOME/$TEAM_DIR/.git" ]; then say "  ~/$TEAM_DIR existe deja, on ne re-clone pas."
  else
    if have gh && gh repo clone "$TEAM_REPO" "$HOME/$TEAM_DIR" 2>/dev/null; then say "  clone : ~/$TEAM_DIR"
    else say "  clone KO (connecte-toi : gh auth login, puis gh repo clone $TEAM_REPO ~/$TEAM_DIR)"; fi
    if [ -f "$HOME/AGENTS.md" ] && ! grep -qF "$AGENTS_MARK" "$HOME/AGENTS.md"; then
      { printf '\n%s\n' "$AGENTS_MARK"; printf -- '- `~/%s` : vault d'\''entreprise partage (contexte et memoire de l'\''organisation).\n' "$TEAM_DIR"; } >> "$HOME/AGENTS.md"
      say "  pointeur ajoute a ~/AGENTS.md"
    fi
  fi
else say "  saute (clone plus tard : gh repo clone <org>/vault ~/Vault-atable)."; fi

# Fin -----------------------------------------------------------------------
step "Termine"
cat <<'EOF'
Premier run, dans l'ordre :
  1. Ouvre ~/Vault dans Obsidian, remplis 0-Home/Me.md (qui tu es, ce que tu veux).
  2. Ouvre ~/Vault-atable (le vault d'entreprise) et lis 0-Home/Onboarding puis 0-Home/Charter.
  3. Lance OpenCode dans un dossier : `opencode`. Essaie la commande /initialisation.
  4. Liste tes projets (1-Projects) et tes roles (caps dans Me.md).
  5. Repere une tache recurrente a transformer en skill.

Cle de modeles : docs/get-bai-key.md. Modeles et alternatives : docs/choosing-models.md.
EOF
