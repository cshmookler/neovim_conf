return function()
    -- Custom global variables
    vim.g._format_on_save    = true

    -- Leader key
    vim.g.mapleader          = " " -- Set global mapping for <Leader>.
    vim.g.maplocalleader     = " " -- Set local mapping for <Leader>.

    -- Disable netrw (replaced with nvim-tree)
    vim.g.loaded_netrw       = 1
    vim.g.loaded_netrwPlugin = 1

    -- Indentation
    vim.opt.shiftwidth       = 4    -- Indentation width.
    vim.opt.smarttab         = true -- Insert spaces instead of tabs.
    vim.opt.expandtab        = true -- Convert existing tabs to spaces.
    vim.opt.tabstop          = 8    -- Tab character width.
    vim.opt.softtabstop      = 8    -- Tab character width (editing operations).
    vim.opt.autoindent       = true -- Keep indentation level for new lines.

    -- Line wrapping
    vim.opt.wrap             = true -- Enable line wrapping.
    vim.opt.linebreak        = true -- Wrap lines by words.
    vim.opt.breakindent      = true -- Wrap lines at the same indentation level.
    vim.opt.breakindentopt   = {
        "min:20", -- Minimum text width kept after indenting.
        "shift:8", -- Hanging indent for wrapped lines.
        "sbr", -- Display the 'showbreak' value before applying the indent.
    }
    vim.opt.showbreak        = "↳ " -- Displayed before wrapped lines.
    -- vim.opt.textwidth        = 80 -- Automatically wrap words past a certain column.

    -- UI
    vim.opt.termguicolors    = true                                 -- 24-bit RGB color support.
    vim.opt.background       = "dark"                               -- Set the default background.
    vim.opt.cmdheight        = 1                                    -- Number of lines given to the command line.
    vim.opt.number           = true                                 -- Show line numbers.
    vim.opt.relativenumber   = true                                 -- Show relative line numbers.
    vim.opt.cursorline       = true                                 -- Highlight the line with the cursor.
    vim.opt.cursorlineopt    = "number,line"                        -- What to highlight relative to the cursor.
    -- vim.opt.laststatus = 0                   -- When to display the status line.
    vim.opt.splitbelow       = true                                 -- Create a new window below the existing one.
    vim.opt.splitright       = true                                 -- Create a new window right of the existing one.
    vim.opt.showtabline      = 2                                    -- When to show the tab line.
    vim.opt.signcolumn       = "yes:2"                              -- Width of the sign column.
    vim.opt.colorcolumn      = string.format("%i", vim.o.textwidth) -- Highlight a specific column.
    vim.opt.completeopt      = "menuone,noselect"                   -- How to display completion options.
    vim.opt.hlsearch         = false                                -- Whether to highlight search results.

    -- Command-line completion
    vim.opt.wildchar         = 14   -- Key for triggering command-line completion.
    vim.opt.wildmenu         = true -- Enhance command-line completion

    -- Miscellaneous
    vim.opt.scrolloff        = 5             -- Minimum number of lines to keep above and below the cursor.
    vim.opt.clipboard        = "unnamedplus" -- Use the system clipboard.
    vim.opt.undofile         = true          -- Persistent undo history.
    vim.opt.undolevels       = 1000          -- Saved undo levels.
    vim.opt.updatetime       = 250           -- Milliseconds between swap file writes when nothing is typed.
    vim.opt.timeoutlen       = 1000          -- Milliseconds to wait for mapped sequences to complete.
    vim.opt.mouse            = ""            -- Mouse support.
    vim.opt.confirm          = true          -- File saving prompt.
end
