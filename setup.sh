#!/usr/bin/env bash
set -euo pipefail #stop le script si il y a une erreur

# ============================================
# Résumé du script
# - Installe les paquets pacman (install/pacman.txt)
# - Installs yay (AUR helper) if missing
# - Installs AUR packages via yay
# - Installs Flatpak + apps
# - Copies home/ into ~
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"
HOME_SRC_DIR="$SCRIPT_DIR/home"

PACMAN_LIST="$INSTALL_DIR/pacman.txt"
AUR_LIST="$INSTALL_DIR/aur.txt"
FLATPAK_LIST="$INSTALL_DIR/flatpak.txt"

#fonction log utilisée plusieurs fois
log() {
  echo "==> $*"
}

log "Installation en cours (repo: $SCRIPT_DIR)"

# --- Basic sanity checks ---
[[ -d "$INSTALL_DIR" ]] || die "Dossier manquant: $INSTALL_DIR"

if [[ ! -f /etc/arch-release ]]; then
  warn "Ce script est prévu pour Arch Linux. /etc/arch-release introuvable."
fi

# --- Update system ---
log "Mise à jour du système (pacman -Syu)"
sudo pacman -Syu --noconfirm

log "Installation des outils requis (base-devel, flatpak)"
sudo pacman -S --needed --noconfirm base-devel flatpak

log 'Activation du dépôt multilibb'
sudo sed -i '/^\s*#\s*\[multilib\]/,/^\s*#\s*Include/ s/^\s*#\s*//' /etc/pacman.conf
sudo pacman -Sy --noconfirm

# --- Install yay if missing ---
if ! command -v yay >/dev/null 2>&1; then
  log "yay non détecté -> installation depuis l'AUR"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  pushd "$tmpdir/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
else
  log "yay déjà présent"
fi

# --- Install pacman packages ---
if [[ -f "$PACMAN_LIST" ]]; then
  log "Installation des paquets pacman depuis $PACMAN_LIST"
  # If pacman.txt is empty, this will no-op
  sudo pacman -S --needed --noconfirm - < "$PACMAN_LIST" || die "Échec installation pacman"
else
  warn "Fichier manquant: $PACMAN_LIST (skip pacman packages)"
fi

# --- Install AUR packages ---
if [[ -f "$AUR_LIST" ]]; then
  log "Installation des paquets AUR depuis $AUR_LIST"
  # Avoid reinstalling yay from the list if it's included
  grep -vE '^(yay|yay-debug)$' "$AUR_LIST" | yay -S --needed --noconfirm - || die "Échec installation AUR"
else
  warn "Fichier manquant: $AUR_LIST (skip AUR packages)"
fi

# --- Flatpak: ensure flathub & install apps ---
log "Configuration de Flathub (si nécessaire)"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true

if [[ -f "$FLATPAK_LIST" ]]; then
  log "Installation des applications Flatpak depuis $FLATPAK_LIST"
  while IFS= read -r app; do
    [[ -z "$app" ]] && continue
    # Ignore comments
    [[ "$app" =~ ^# ]] && continue
    flatpak install -y flathub "$app" || warn "Flatpak: échec d'installation de $app (on continue)"
  done < "$FLATPAK_LIST"
else
  warn "Fichier manquant: $FLATPAK_LIST (skip flatpak apps)"
fi

# --- Copy home/ contents into ~ ---
if [[ -d "$HOME_SRC_DIR" ]]; then
  log "Copie de $HOME_SRC_DIR/ vers $HOME"
  # -a preserve permissions/timestamps; avoid ownership issues if copied from another system
  cp -a --no-preserve=ownership "$HOME_SRC_DIR/." "$HOME/"
fi

log "Terminé ✅"
echo "Conseil : déconnecte/reconnecte ta session (ou redémarre) pour appliquer certains réglages."
