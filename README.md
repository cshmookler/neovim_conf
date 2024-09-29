# **neovim_conf**

The default Neovim configuration for [MOOS](https://github.com/cshmookler/moos). Includes several features by default:

 - Programming language support (C, C++, Python, Lua, HTML, CSS, JS, TS, Bash, JSON):
    - Syntax highlighting
    - Intellisense
    - Code suggestions and completion
    - Static analysis
    - Automatic formatting on write
 - Integrated terminal
 - Different workspaces:
    - Each tab is its own workspace
    - Each workspace has its own working directory
 - Window multiplexing
    - View multiple files in the same tab by opening them in separate panes.
    - View different parts of the same file by splitting it into two panes.
 - Spoken language support (English by default):
    - Word completion from a pre-generated dictionary
 - Filesystem integration:
    - Builtin file explorer for creating/trashing/deleting/renaming/copying/moving files and directories
    - Path completion in commands and code
 - Git integration:
    - Added/modified/removed lines indicated in the sign column
    - Status of files/directories shown in the file explorer
 - Browser integration:
    - Preview files in a web browser with :Vivify

## Installation

#### 1.&nbsp; Install Neovim 0.10.x, Aspell, xsel (optional), Vivify (optional), and LSP servers (optional).

##### Linux (MOOS):

```bash
sudo pacman -S neovim aspell-en xsel vscode-html-languageserver vscode-json-languageserver vscode-css-languageserver yaml-language-server eslint-language-server clang lua-language-server vim-language-server jedi-language-server bash-language-server rust-analyzer texlab
yay -S vivify
```

#### 2.&nbsp; Clone this project to the Neovim configuration directory.

```bash
git clone https://github.com/cshmookler/neovim_conf ~/.config/nvim
```

#### 3.&nbsp; Generate the dictionary file.

```bash
aspell dump master | aspell extract > ~/.local/share/nvim/dict
```

#### 4.&nbsp; Start Neovim. All plugins will be automatically downloaded and installed.

```bash
nvim
```

#### 5.&nbsp; Once all plugins are installed, press 'q' to exit the plugin installation window. Enter ':checkhealth' to verify that everything is working properly.

```vim
:checkhealth
```

## TODO

- [X] Fix washed out colors in the integrated terminal.
- [ ] Create keymaps for Vivify.
