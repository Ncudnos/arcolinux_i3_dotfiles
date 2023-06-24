# Table of content


<!-- vim-markdown-toc Redcarpet -->

* [ArcoLinux](#arcolinux)
    * [i3-config-folders](#i3-config-folders)
        * [0. Install Arco-Linux i3wm](#0-install-arco-linux-i3wm)
        * [1. Install packages:](#1-install-packages)
        * [2. Move packages](#2-move-packages)
        * [3. For `neovim`](#3-for-neovim)

<!-- vim-markdown-toc -->

# ArcoLinux

## i3-config-folders

### 0. Install Arco-Linux i3wm

- I do `offline install` because I just want the minimal i3wm installation of Arco

### 1. Install packages:

- I use `yay`, for these steps, you can actually install packages using pacman, but, because of some of my packages just exists in AUR so...

```zsh
yay -Syyu git curl gcc jdk-openjdk jre-openjdk neovim lsd python-pip zip unzip xclip ibus ibus-bamboo teamviewer virtualbox brave-bin brillo flameshot nvm xournalpp && yay -Rncs firefox
```

### 2. Move packages

- Clone the repo:

```zsh
git clone https://github.com/ncudnos/arcolinux_i3_dotfiles
```

- Go to the `arcolinux_i3_dotfiles` folder, then:

```zsh
rm ~/.config/alacritty ~/.config/neofetch ~/.config/rofi ~/.config i3 && mv alacritty ~/.config/ && mv i3 ~/.config/ && mv neofetch ~/.config/ && mv nvim ~/.config/ && mv rofi ~/.config/ && rm ~/.config/mimeapps.list && mv mimeapps.list ~/.config/ && sudo rm -rf /etc/profile && sudo mv profile /etc/ && rm -rf ~/.zshrc && mv zshrc_config .zshrc && mv .zshrc ~
```

- Also, remember set zsh as default shell:

```zsh
chsh -s $(which zsh)
```
        

- Use `Ctrl + Shift + r` to reset ArcoLinux OR reboot to achieve result


### 3. For `neovim`

- Install vim-plug:

```zsh

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

```

- And then, open neovim with `nvim` and then run `:PlugInstall` and then `:call mkdp#util#install()`
