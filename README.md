# Arch Linux - COSMOS Setup

This repo contains my personal Arch Linux setup. 
It automates:
- Package installation (pacman + YAY + flatpak)
- Desktop configuration
- User configuration files

# setup

Télécharger le script
```bash
git clone https://github.com/simGorecki/archSetup.git
```

Rendre le script exécutable
```bash
cd archSetup
chmod +x setup.sh
```

Exécution du script
```bash
./setup.sh
```

Supprimer le script
```bash
cd ..
rm -rf archSetup
```

# Mettre à jours le dotfiles
```bash
sudo chmod +x importDotfiles.sh
./importDotfiles.sh
git add -A
git commit -m "description des modifications"
git push
```

# Ajouter des liens dans le dotfile

Editer le fichier importDotfiles.sh
Ajouter le path des fichiers / dossiers qu'on veut sauvegarder dans le dotfile dans le tableau au début du fichier.
```bash
SOURCES=( #mettre les paths ici
```

