# **My Neovim Configuration**

This is my personal Neovim configuration. It includes syntax highlighting, autocompletion, code linting, git integration, filesystem integration, and other useful plugins.

## **Installation**

**1.** Install Neovim 0.10.x (nightly).

**2.** Clone this repository in your Neovim configuration directory.

```bash
git clone https://github.com/cshmookler/config.nvim ~/.config/nvim
```

**3.** Start NeoVim. Once all plugins are installed, press 'q' and enter ':checkhealth'.

```bash
nvim
```

```vim
:checkhealth
```

## **TODO**

- [ ] Create a pacman package for this configuration.
- [ ] Adapt inlay hints to work with Clang 16+.
- [ ] Alter SudoWrite to prompt for the sudo password when necessary.