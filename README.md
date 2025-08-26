#+TITLE: dotfiles

This repo contains my dotfile configuration.
These days I primarily use OMARCHY via the [[https://omarchy.org][Arch Linux distribution]].

I manage the various configuration files in this repo using [[https://www.gnu.org/software/stow/][GNU Stow]]. This allows me to set up symlinks for all of my dotfiles using a single command:

#+begin_src sh
stow .
#+end_src
