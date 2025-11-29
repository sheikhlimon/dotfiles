# Dotfiles — OMARCHY Setup

This repository contains my personal dotfiles, designed around [OMARCHY](https://omarchy.org).

> 💡 **OMARCHY Philosophy**: Take anything and make it your own. These configs are a starting point - feel free to take, modify, and customize to fit your workflow.

## Features

- 🖥️ Hyprland window manager with OMARCHY-aligned tweaks
- 🍭 Waybar themed to match OMARCHY
- ⚡ Fully customized Neovim with blazingly fast setup
- 🧩 Zsh + Starship prompt with Oh My Zsh plugins
- 📝 Kitty & Ghostty terminal configurations
- 🗂️ Yazi with custom theme
- 📦 Lazygit and Lazydocker configs
- 🔤 Fontconfig (Victor Mono Nerd Font)
- 🛠️ Tmux configuration with plugins and custom keybindings
- 📋 Git configuration
- 🚀 Automated scripts for app installation and database setup

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
