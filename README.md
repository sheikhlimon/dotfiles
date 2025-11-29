# Dotfiles — OMARCHY Setup

This repository contains my personal dotfiles, designed around [OMARCHY](https://omarchy.org).

## Features

- 🖥️ Hyprland window manager with OMARCHY-aligned tweaks
- 🍭 Waybar themed to match OMARCHY
- ⚡ Neovim with a fast, minimal Lua setup
- 🧩 Zsh + compinit fixes + Starship prompt
- 📝 Kitty & Ghostty terminal configurations
- 🗂️ Yazi with custom theme
- 📦 Lazygit and Lazydocker configs
- 🔤 Fontconfig (Victor Mono italics → regular fallback)
- 🛠️ Scripts for database setup and other utilities

## Installation

**Clone the repository:**

```bash
git clone https://github.com/sheikhlimon/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

**Install specific configs (example):**

```bash
stow hypr
stow zsh
stow nvim
stow kitty
```

**Install everything:**

```bash
stow */
```

> Make sure to remove or back up existing config files before stowing.
