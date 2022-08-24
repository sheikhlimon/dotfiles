# sheikhlimon Dotfiles
**Arch Linux** & **bspwm** dotfiles!

![1](https://user-images.githubusercontent.com/76746201/186396011-acc6a278-6323-48b6-a3ed-459165bd2673.png)



<details>
<summary><b>
Detailed information and dependencies
</b></summary>

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

2. Install an AUR helper (for example, `yay` in `"$HOME"/.srcs`).
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
    Make sure to delete this folder ~/.local/share/nvim
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    ln -s ./.config/nvchad/custom ./.config/nvim/lua/custom
    ```


## SIDE NOTE

**Not as beautiful as your mom but it's good enough**

But still, if you need any help, you can contact me on **[discord](https://discord.gg/nArdjdyH)**.


