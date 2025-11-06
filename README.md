# **neovim_conf**

The default Neovim configuration for [MOOS](https://github.com/cshmookler/moos). Includes several features by default:

 - Programming language support (C, C++, C#, Rust, Python, Lua, Vim, HTML, CSS, JS, TS, Bash, JSON, YAML, LaTeX, OpenSCAD, SystemVerilog):
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

## Installation

#### 1.&nbsp; Install required packages.

Install Neovim 0.10.x, Treesitter CLI, Aspell, xsel (optional), LSP servers (optional), Formatters (optional), and LaTeX.

##### Linux (MOOS):

```bash
sudo pacman -S neovim tree-sitter-cli aspell-en xsel vscode-html-languageserver vscode-json-languageserver vscode-css-languageserver typescript-language-server yaml-language-server clang lua-language-server jedi-language-server bash-language-server rust-analyzer python-black mypy flake8 usort texlab $(pacman -Sgq 'texlive') tinyxxd
yay -S vim-language-server csharp-ls openscad-lsp verible-bin
```

#### 2.&nbsp; Clone this project to the Neovim configuration directory.

```bash
git clone https://github.com/cshmookler/neovim_conf ~/.config/nvim
```

#### 3.&nbsp; Generate the dictionary file.

```bash
aspell dump master > /etc/nvim/dict
```

#### 4.&nbsp; Start Neovim.

All plugins will be automatically downloaded and installed.

```bash
nvim
```

#### 5.&nbsp; Verify the integrity of the installation.

Once all plugins are installed, press 'q' to exit the plugin installation window. Enter ':checkhealth' to verify that everything is working properly.

```vim
:checkhealth
```
