# dotfiles

Personal configuration files for Omarchy (Arch Linux) and Fedora, managed with [yadm](https://yadm.io/).

## Quick Start (New Machine)

### 1. Install yadm
- **Arch / Omarchy:** `sudo pacman -S yadm`
- **Fedora:** `sudo dnf install yadm`

### 2. Clone and Bootstrap
Clone the repository and run the automated installer:

```bash
yadm clone --bootstrap git@github.com:sheikhlimon/dotfiles.git
```

### 3. Decrypt Secrets
Decrypt private SSH keys, Claude skills, and API credentials:

```bash
yadm decrypt
```

## Tool Stack

- **Manager:** [yadm](https://yadm.io/) with GPG archive encryption and automated lifecycle hooks
- **Shell:** Modular Zsh (`env`, `options`, `completions`, `plugins`, `tools`, `aliases`)
- **Plugin Manager:** [Antidote](https://getantidote.github.io/) with static bundle compilation
- **Prompt:** [Starship](https://starship.rs/)
- **Fuzzy Finder:** [FZF](https://github.com/junegunn/fzf) + [fzf-tab](https://github.com/Aloxaf/fzf-tab) (context-aware previews via `bat` and `eza`)
- **Editor:** [Neovim](https://neovim.io/) and [VS Code](https://code.visualstudio.com/)
- **Terminals:** [Ghostty](https://ghostty.org/) and [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Window Manager:** [Hyprland](https://hyprland.org/)
- **File Manager:** [Yazi](https://yazi-rs.github.io/)
- **Git:** [Delta](https://github.com/dandavison/delta) (Flexoki Light theme) and [Lazygit](https://github.com/jesseduffield/lazygit)
- **Multiplexer:** [Tmux](https://github.com/tmux/tmux)
- **Containers:** [Lazydocker](https://github.com/jesseduffield/lazydocker) + Podman / Docker

## Directory Structure

```
~
├── .config/
│   ├── hypr/          # Hyprland window manager configuration
│   ├── nvim/          # Neovim configuration and LSP settings
│   ├── zsh/           # Modular Zsh configuration (env, options, tools, aliases)
│   ├── ghostty/       # Ghostty terminal configuration
│   ├── kitty/         # Kitty terminal configuration
│   ├── lazygit/       # Lazygit configuration (Flexoki Light)
│   ├── lazydocker/    # Lazydocker configuration
│   ├── starship/      # Starship prompt configuration
│   ├── yazi/          # Yazi terminal file manager
│   └── yadm/          # Bootstrap installer, encryption list, and hooks
├── .local/
│   ├── bin/           # Global user scripts (screenshot, screenrecord)
│   └── share/yadm/    # Encrypted archive vault (archive)
├── .gitconfig         # Git configuration (Delta pager, zdiff3)
├── .tmux.conf         # Tmux multiplexer configuration
└── .zshrc             # Zsh entrypoint loader
```

## Daily Workflow

| Command | Description |
| :--- | :--- |
| `yadm status` | Check status of tracked dotfiles |
| `yadm diff` | View unstaged changes |
| `yadm add <file>` | Stage modified or new configuration |
| `yadm commit -m "message"` | Commit staged changes |
| `yadm push` | Push changes to remote repository |
| `yadm pull` | Pull updates from remote repository |
| `yadm encrypt` | Re-encrypt private files (auto-staged via hook) |
| `yadm decrypt` | Decrypt private credentials on current machine |
