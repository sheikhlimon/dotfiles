# source first then run install functions
# source ~/.post-install.sh

install_paru() {
  if [[ ! -f /etc/arch-release ]]; then
    echo "Not Arch Linux. Skipping paru install."
    return
  fi

  if command -v paru &>/dev/null; then
    echo "paru is already installed."
    return
  fi

  echo "Installing paru (AUR helper)..."

  # Install base-devel and git if missing (needed to build paru)
  sudo pacman -S --needed --noconfirm base-devel git

  # Clone paru repo to a temp dir
  tmp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmp_dir/paru"

  # Build and install paru
  (
    cd "$tmp_dir/paru"
    makepkg -si --noconfirm
  )

  # Cleanup
  rm -rf "$tmp_dir"

  echo "paru installed!"
}

# Function to install missing zsh plugins (call manually: install_zsh_plugins)
install_zsh_plugins() {
  local plugins_to_install=(
    "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
  )

  for plugin_info in "${plugins_to_install[@]}"; do
    local plugin_name="${plugin_info%|*}"
    local plugin_url="${plugin_info#*|}"
    local plugin_path="$ZSH/custom/plugins/$plugin_name"

    if [[ ! -d "$plugin_path" ]]; then
      echo "Installing $plugin_name..."
      git clone "$plugin_url" "$plugin_path"
    else
      echo "$plugin_name already installed"
    fi
  done
  echo "Plugin installation complete! Restart your shell or run 'source ~/.zshrc'"
}

install_zshrc_support() {
  if [[ -f /etc/arch-release ]]; then
    echo "Detected Arch Linux"
    sudo paru -S --needed multitail eza fd bat peco yazi zoxide trash-cli fzf

  elif [[ -f /etc/debian_version ]]; then
    echo "Detected Debian-based system"
    sudo apt update
    sudo apt install -y multitail eza bat peco fzf zoxide trash-cli

    # Optional: Install `yazi` if it's not in apt (available via cargo or deb)
    if ! command -v yazi &>/dev/null; then
      echo "yazi not found in apt; installing from GitHub..."
      tmp_dir=$(mktemp -d)
      (
        cd "$tmp_dir"
        curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi_amd64.deb
        sudo dpkg -i yazi_amd64.deb
      )
      rm -rf "$tmp_dir"
    fi

  else
    echo "Unsupported OS — only Arch and Debian-based systems are supported for now."
  fi
}

install_my_apps() {
  # Define apps to install
  local arch_official=(
    kitty
    discord
    telegram-desktop
    mpv
    okular
    neovim
    haruna
    fnm
  )

  local arch_aur=(
    google-chrome
    visual-studio-code-bin
    mongodb-compass-bin
    postman-bin
    protonvpn-cli
    foliate
    ghostty
    zen-browser-bin
  )

  local debian_official=(
    kitty
    discord
    telegram-desktop
    mpv
    okular
    neovim
    haruna
  )

  # Snap apps (Debian)
  local debian_snap_apps=(
    code
    postman
    zoom-client
    protonvpn
  )

  # Helper to check and install packages on Arch
  install_arch_pkgs() {
    local pkg_list=("$@")
    local to_install=()
    for pkg in "${pkg_list[@]}"; do
      if ! pacman -Qi "$pkg" &>/dev/null && ! paru -Qi "$pkg" &>/dev/null; then
        to_install+=("$pkg")
      else
        echo "$pkg already installed."
      fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
      echo "Installing Arch packages: ${to_install[*]}"
      sudo pacman -S --needed "${to_install[@]}"
    fi
  }

  # Helper to install AUR packages with paru
  install_arch_aur_pkgs() {
    local aur_list=("$@")
    for pkg in "${aur_list[@]}"; do
      if ! paru -Qi "$pkg" &>/dev/null; then
        echo "Installing AUR package: $pkg"
        paru -S --needed "$pkg"
      else
        echo "AUR package $pkg already installed."
      fi
    done
  }

  # Helper to check and install Debian packages
  install_debian_pkgs() {
    local pkgs=("$@")
    local to_install=()
    for pkg in "${pkgs[@]}"; do
      if ! dpkg -s "$pkg" &>/dev/null; then
        to_install+=("$pkg")
      else
        echo "$pkg already installed."
      fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
      echo "Installing Debian packages: ${to_install[*]}"
      sudo apt install -y "${to_install[@]}"
    fi
  }

  # Helper to install snap apps if snap exists
  install_snap_apps() {
    if ! command -v snap &>/dev/null; then
      echo "snap not found, installing snapd..."
      sudo apt install -y snapd
      sudo systemctl enable --now snapd.socket
    fi

    for snap_app in "${debian_snap_apps[@]}"; do
      if ! snap list | grep -q "^$snap_app "; then
        echo "Installing snap app: $snap_app"
        sudo snap install "$snap_app" --classic 2>/dev/null || sudo snap install "$snap_app" 2>/dev/null
      else
        echo "Snap app $snap_app already installed."
      fi
    done
  }

  echo "Updating package lists..."

  if [[ -f /etc/arch-release ]]; then
    echo "Detected Arch Linux"
    sudo pacman -Syu --needed

    install_arch_pkgs "${arch_official[@]}"
    install_arch_aur_pkgs "${arch_aur[@]}"

    # fnm install
    if ! command -v fnm &>/dev/null; then
      echo "Installing fnm..."
      curl -fsSL https://fnm.vercel.app/install | bash
      # User should restart shell or source profile to use fnm PATH
    fi
    eval "$(fnm env)"
    fnm install latest
    fnm use latest
    fnm default latest

  elif [[ -f /etc/debian_version ]]; then
    echo "Detected Debian/Ubuntu"

    sudo apt update

    install_debian_pkgs "${debian_official[@]}"

    install_snap_apps

    # fnm install
    if ! command -v fnm &>/dev/null; then
      echo "Installing fnm (Fast Node Manager)..."
      curl -fsSL https://fnm.vercel.app/install | bash
      # User should restart shell or source profile to use fnm PATH
    fi
    eval "$(fnm env)"
    fnm install latest
    fnm use latest
    fnm default latest

  else
    echo "Unsupported distro. Aborting."
    return 1
  fi

  echo "Installation complete."
}

setup_databases() {
  echo "Starting MongoDB and PostgreSQL setup..."

  if [[ -f /etc/arch-release ]]; then
    echo "Detected Arch Linux"

    # Install MongoDB and PostgreSQL if missing
    if ! pacman -Qi mongodb &>/dev/null; then
      echo "Installing MongoDB..."
      sudo pacman -S --needed mongodb
    else
      echo "MongoDB already installed."
    fi

    if ! pacman -Qi postgresql &>/dev/null; then
      echo "Installing PostgreSQL..."
      sudo pacman -S --needed postgresql
    else
      echo "PostgreSQL already installed."
    fi

    # Enable and start MongoDB service
    if ! systemctl is-active --quiet mongod; then
      sudo systemctl enable --now mongod
      echo "MongoDB service started and enabled."
    else
      echo "MongoDB service already running."
    fi

    # Initialize PostgreSQL database if not initialized
    if [[ ! -d /var/lib/postgres/data ]]; then
      echo "Initializing PostgreSQL database..."
      sudo -iu postgres initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
    fi

    # Enable and start PostgreSQL service
    if ! systemctl is-active --quiet postgresql; then
      sudo systemctl enable --now postgresql
      echo "PostgreSQL service started and enabled."
    else
      echo "PostgreSQL service already running."
    fi

  elif [[ -f /etc/debian_version ]]; then
    echo "Detected Debian/Ubuntu"

    # Install MongoDB (official packages)
    if ! dpkg -s mongodb-org &>/dev/null; then
      echo "Installing MongoDB..."
      # Add MongoDB repo and key (if not already added)
      if ! grep -q "mongodb-org" /etc/apt/sources.list.d/mongodb-org-*.list 2>/dev/null; then
        wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
        echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org.list
        sudo apt update
      fi
      sudo apt install -y mongodb-org
    else
      echo "MongoDB already installed."
    fi

    # Install PostgreSQL
    if ! dpkg -s postgresql &>/dev/null; then
      echo "Installing PostgreSQL..."
      sudo apt install -y postgresql
    else
      echo "PostgreSQL already installed."
    fi

    # Enable and start MongoDB service
    if ! systemctl is-active --quiet mongod; then
      sudo systemctl enable --now mongod
      echo "MongoDB service started and enabled."
    else
      echo "MongoDB service already running."
    fi

    # Enable and start PostgreSQL service
    if ! systemctl is-active --quiet postgresql; then
      sudo systemctl enable --now postgresql
      echo "PostgreSQL service started and enabled."
    else
      echo "PostgreSQL service already running."
    fi

  else
    echo "Unsupported distro. Aborting."
    return 1
  fi

  echo "Database setup complete."
}
