# Dotfiles

This repository contains my personal dotfile configurations.
These days I primarily use [OMARCHY](https://omarchy.org) an opinionated Arch + Hyprland Setup.

## Managing Dotfiles

I manage all configuration files using [GNU Stow](https://www.gnu.org/software/stow/), which allows me to create symlinks easily.

To set up all dotfiles:

```sh
cd ~/dotfiles   # Navigate to your dotfiles repository
stow <package>  # Symlink packages
```
