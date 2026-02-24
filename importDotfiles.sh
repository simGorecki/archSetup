#!/bin/bash

SOURCES=(
    "$HOME/.config/btop"
    "$HOME/.config/cosmic"
    "$HOME/.config/help"
    "$HOME/.config/kitty"
    "$HOME/.config/sublime-text"
    "$HOME/.config/systemd"
    "$HOME/.config/autostart/week-tray.desktop"
    "$HOME/.bashrc"
    "$HOME/.profile"
    "$HOME/.vimrc"

    "$HOME/Scripts/numeroSemaine"

    "$HOME/Images/Wallpapers"
)

DEST_ROOT="./home"

rm -rf -- "$DEST_ROOT"
mkdir $DEST_ROOT

for SOURCE in "${SOURCES[@]}"; do
    if [ -e "$SOURCE" ]; then
        REL_PATH="${SOURCE#$HOME/}"
        DEST_PATH="$DEST_ROOT/$REL_PATH"

        echo "Copie de $SOURCE"

        mkdir -p "$(dirname "$DEST_PATH")"
        cp -a "$SOURCE" "$DEST_PATH"
    else
        echo "  $SOURCE n'existe pas"
    fi
done

echo "Terminé."