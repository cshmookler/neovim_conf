-- List languages that require language-specific highlighting.
-- Highlighting for these languages are installed by default, but others are
-- installed automatically.
local languages = {
    "c",
    "cpp",
    "lua",
    "python",
    "java",
    "javascript",
    "typescript",
    "vimdoc",
    "vim",
    "bash",
}

-- List lsp servers to install.
local lsp_servers = {
    ["lua_ls"] = {
        lsp_settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    ["clangd"] = {},
    ["pyright"] = {},
    -- ["swift-mesonlsp"] = { lsp_settings = {}, lspconfig_settings = {}, },
    ["jdtls"] = {
        autosetup = true,
        lspconfig_settings = {
            cmd = {
                "jdtls",
                "-configuration",
                vim.fn.expand("$HOME/.cache/jdtls/config"),
                "-data",
                vim.fn.expand("$HOME/.cache/jdtls/workspace"),
            },
            init_options = {
                jvm_args = {},
                workspace = vim.fn.expand("$HOME/.cache/jdtls/workspace"),
            },
            root_dir = function(_)
                return vim.fn.getcwd()
            end,
        },
    },
}

-- Install lazy.nvim if it isn't already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.termguicolors = true -- Enable 24-bit RGB color.
vim.opt.background = "dark"  -- Set the defualt background.
vim.g.mapleader = " "        -- Set global mapping for <Leader>.
vim.g.maplocalleader = " "   -- Set local mapping for <Leader>.

local icons_enabled = false  -- Whether to enable icons.

-- Install plugins with lazy.nvim.
local lazy = require("lazy")
lazy.setup(
    require("lazy_plugins")(languages, lsp_servers, icons_enabled),
    require("opt.lazy")
)

-- Indentation
vim.opt.shiftwidth = 4    -- Indentation width.
vim.opt.smarttab = true   -- Insert spaces instead of tabs.
vim.opt.expandtab = true  -- Convert existing tabs to spaces.
vim.opt.tabstop = 8       -- Tab character width.
vim.opt.softtabstop = 4   -- Tab character width (editing operations).
vim.opt.autoindent = true -- Keep indentation level for new lines.

-- Line wrapping
vim.opt.wrap = true        -- Enable line wrapping.
vim.opt.linebreak = true   -- Wrap lines by words.
vim.opt.breakindent = true -- Wrap lines at the same indentation level.
vim.opt.breakindentopt = {
    "min:20",
    "shift:2",  -- Hanging indent for wrapped lines.
}
-- vim.opt.showbreak = "+++ "  -- Displayed before wrapped lines.
-- vim.opt.textwidth = 80 -- Wrap words past a certain column.

-- UI
vim.opt.cmdheight = 1         -- Hide the command line unless it is used.
vim.opt.number = true         -- Show line numbers.
vim.opt.relativenumber = true -- Show relative line numbers.
vim.opt.cursorline = true     -- Highlight the line with the cursor.
vim.opt.cursorcolumn = true   -- Highlight the column with the cursor.
vim.opt.cursorlineopt = "number,line"
-- vim.opt.laststatus = 0  -- When to display the status line.
vim.opt.splitbelow = true                                  -- Create a new window below the existing one.
vim.opt.splitright = true                                  -- Create a new window right of the existing one.
vim.opt.showtabline = 1                                    -- When to show tha tab line.
vim.opt.signcolumn = "yes:2"                               -- When to show the sign column.
vim.opt.colorcolumn = string.format("%i", vim.o.textwidth) -- Color a specific column.
vim.opt.completeopt = "menuone,noselect"                   -- How to display completion options.
vim.opt.hlsearch = false

-- Completion
vim.opt.wildchar = 14   -- Key for triggering command-line completion.
vim.opt.wildmenu = true -- Enhance command-line completion.

-- Miscellaneous
vim.opt.scrolloff = 8             -- Minimum number of lines to keep above and below the cursor.
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard.
vim.opt.undofile = true           -- Persistent undo history.
vim.opt.undolevels = 1000         -- Saved undo levels.
vim.opt.updatetime = 250          -- Milliseconds between swap file writes when nothing is typed.
vim.opt.timeoutlen = 1000         -- Milliseconds to wait for a mapped sequence to complete.
vim.opt.mouse = ""                -- Mouse support.

-- Switch between windows.
vim.cmd.nnoremap("<C-h>", "<C-w>h")
vim.cmd.nnoremap("<C-j>", "<C-w>j")
vim.cmd.nnoremap("<C-k>", "<C-w>k")
vim.cmd.nnoremap("<C-l>", "<C-w>l")

-- Tab navigation.
vim.cmd.nnoremap("<C-n>", ":tabprevious<CR>")
vim.cmd.nnoremap("<C-m>", ":tabnext<CR>")

-- Integrated terminal.
vim.cmd.nnoremap("<Leader>t", ":split<CR>:terminal<CR>A")
vim.cmd.tnoremap("<C-e>", "<C-\\><C-n>")
vim.cmd.tnoremap("<C-h>", "<C-\\><C-n><C-w>h")
vim.cmd.tnoremap("<C-j>", "<C-\\><C-n><C-w>j")
vim.cmd.tnoremap("<C-k>", "<C-\\><C-n><C-w>k")
vim.cmd.tnoremap("<C-l>", "<C-\\><C-n><C-w>l")

-- Automatically close the integrated terminal when the process terminates.
vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
       vim.cmd("close")
    end
})

vim.cmd.au("BufNewFile,BufRead", "*.py.tmpl", ":set filetype=python")
vim.cmd.au("BufNewFile,BufRead", "meson.build.tmpl", ":set filetype=meson")
vim.cmd.au("BufNewFile,BufRead", "*.hpp.in.tmpl", ":set filetype=cpp")
vim.cmd.au("BufNewFile,BufRead", "*.cpp.tmpl", ":set filetype=cpp")
