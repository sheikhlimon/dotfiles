<h2 align="center"> ━━━━━━  ❖  ━━━━━━ </h2>

# sheikhlimon Dotfiles
**Arch Linux** & **bspwm** dotfiles!

[Information](#information) ·
[Installation](#manual-installation) ·
[Keybindings](#keybindings) ·
[SideNote](#sidenote)

![1](https://user-images.githubusercontent.com/76746201/186396011-acc6a278-6323-48b6-a3ed-459165bd2673.png)

![2](https://user-images.githubusercontent.com/76746201/186396310-5c805cec-dae1-48c4-8efa-be413487b0f6.png)

## Information

- **Guide** [Installing Arch] (https://itsfoss.com/install-arch-linux)
- **OS:** [Arch Linux](https://archlinux.org)
- **WM:** [bspwm](https://github.com/baskerville/bspwm)
- **Terminal:** [xfce4-terminal](https://github.com/xfce-mirror/xfce4-terminal)
- **Bar:** [polybar](https://github.com/polybar/polybar)
- **Shell:** [zsh](https://www.zsh.org/)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)
- **Notification Deamon:** [dunst](https://github.com/dunst-project/dunst)

<details>
<summary><b>
Detailed information and dependencies
</b></summary>

### Fonts
	
**Icons:** [Feather](https://github.com/AT-UI/feather-font/blob/master/src/fonts/feather.ttf)    
**Interface Font:** [Open sans](https://fonts.google.com/specimen/Open+Sans#standard-styles)    
**Monospace Font:** [Roboto mono](https://fonts.google.com/specimen/Roboto+Mono#standard-styles)    
**Polybar Font:** [Iosevka nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Iosevka)

### Dependencies

**Base:** alsa-utils base-devel git pulseaudio pulseaudio-alsa xorg 

**Required:** lightdm bspwm xfce4-terminal alacritty htop visual-studio-code dunst feh firefox libnotify mpv nemo neofetch neovim papirus-icon-theme picom polybar ranger rofi maim scrot slop xclip zathura zsh viewnior lxapperance pavucontrol discord geany zoom xdotool xdg-user-dirs sxhkd gpick 

**Emoji:** fonts: noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts-jetbrains-mono nerd-fonts-hack adobe-source-code-pro-fonts

</details>


### Manual Installation

1. Clone this repository.
    ```sh
    git clone https://www.github.com/sheikhlimon/dotfiles.git
    ```

2. Install an AUR helper (for example, `paru` in `"$HOME"/.srcs`).
    ```sh
    git clone https://aur.archlinux.org/paru.git "$HOME/.scrs/paru"
	cd "$HOME"/.srcs/paru/ && makepkg -si
    ```

3. Install dependencies.
    ```sh
    paru -S --needed xfce4-terminal alacritty htop visual-studio-code dunst feh firefox libnotify mpv nemo neofetch neovim papirus-icon-theme picom polybar ranger rofi maim scrot slop xclip zathura zsh viewnior lxapperance pavucontrol discord geany zoom xdotool xdg-user-dirs sxhkd gpick nordic-darker-theme bat unimatrix
    ```

4. Create default directories.
    ```sh
    mkdir -p "$HOME"/.config
    mkdir -p  /usr/local/bin
    mkdir -p  /usr/share/themes
    ```

5. Copy configs, scripts, fonts, set gtk theme, vsc configs, zsh config.
    ```sh
    cp -r ./dotfiles/.config/* "$HOME"/.config
    sudo cp -r ./dotfiles/scripts/* /usr/local/bin
    sudo cp -r ./dotfiles/fonts/* /usr/share/fonts
    cp -r ./dotfiles/.zshrc "$HOME"
    cp -r ./dotfiles/.zshrc-personal "$HOME"
    cp -r ./dotfiles/.gitconfig "$HOME"
    ```

6. set zsh as default shell, refresh font cache.
    ```sh
    chsh -s /bin/zsh
    sudo chsh -s /bin/zsh
    fc-cache -fv
    ```

7. set oh-my-zsh
    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    cp -r ./.oh-my-zsh ./.srcs/
    ```

8. set nvim
    ```sh
    rm -rf ~/.local/share/nvim
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    ln -s ./.config/nvchad/custom ./.config/nvim/lua/custom
    ```

## Keybindings
|        Keybind             |                 Function                 |
| -------------------------- | ---------------------------------------- |
| `Ctrl + Shft + Q`          | Log Out Session                          |
| `Ctrl + Shft + R`          | Reload Current Session                   |
| `Super + [1..4]`           | Switches to Workspace 1 to 4             |
| `Super + Shft + [1..4]`    | Move Apps/Windows to Workspace 1 to 4    |
| `Super + X`                | Launch Powermenu                         |
| `Super + Enter`            | Launch Terminal (xfce4-terminal)         |
| `Super + C`                | Close/Kill Window                        |
| `Super + M`                | Launch rofi                              |
| `Super + Shft + W`         | Launch Firefox                           |
| `Super + Shft + F`         | Launch Nemo                              |
| `Super + Shft + R`         | Ranger Quick Launch                      |
| `PrtSc`                    | Screenshot                               |
| `Ctrl + PtrSc`             | Screenshot Active Window                 |
| `Ctrl + Alt + PrtSc`       | Screenshot Selected Area                 |


## SideNote

Mostly riced for Desktop.
Feel free to create issue or pull request.    
If you need any help, you can contact me on **[discord](https://discord.gg/nArdjdyH)**.

Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.    
Copyright (C) 2022 sheikhlimon.

## Credits

Keyitdev[github](https://github.com/Keyitdev/dotfiles/tree/v3 took some stuffs from this guy
siduck[github](https://https://github.com/NvChad/NvChad) the awesome neovim
r/unixporn[reddit](https://www.reddit.com/r/unixporn/) where I found them and others for inspirations

