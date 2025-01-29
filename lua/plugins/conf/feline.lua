return function()
    local colors = require("catppuccin.palettes").get_palette()
    local catppuccin_feline = require('catppuccin.groups.integrations.feline')
    local utils = require("catppuccin.utils.colors")

    catppuccin_feline.setup({
        assets = {
            left_separator = "",
            right_separator = "",
            mode_icon = "",
            dir = "󰉖",
            file = "󰈙",
            lsp = {
                server = "󰅡",
                error = "",
                warning = "",
                info = "",
                hint = "",
            },
            git = {
                branch = "",
                added = "",
                changed = "",
                removed = "",
            },
        },
        sett = {
            text = utils.vary_color({ latte = colors.base }, colors.surface0),
            bkg = utils.vary_color({ latte = colors.crust }, colors.surface0),
            diffs = colors.mauve,
            extras = colors.overlay1,
            curr_file = colors.maroon,
            curr_dir = colors.flamingo,
            show_modified = true,      -- show if the file has been modified
            show_lazy_updates = false, -- show the count of updatable plugins from lazy.nvim
            -- need to set checker.enabled = true in lazy.nvim first
            -- the icon is set in ui.icons.plugin in lazy.nvim
        },
        mode_colors = {
            ["n"] = { "NORMAL", colors.lavender },
            ["no"] = { "N-PENDING", colors.lavender },
            ["i"] = { "INSERT", colors.green },
            ["ic"] = { "INSERT", colors.green },
            ["t"] = { "TERMINAL", colors.green },
            ["v"] = { "VISUAL", colors.flamingo },
            ["V"] = { "V-LINE", colors.flamingo },
            ["�"] = { "V-BLOCK", colors.flamingo },
            ["R"] = { "REPLACE", colors.maroon },
            ["Rv"] = { "V-REPLACE", colors.maroon },
            ["s"] = { "SELECT", colors.maroon },
            ["S"] = { "S-LINE", colors.maroon },
            ["�"] = { "S-BLOCK", colors.maroon },
            ["c"] = { "COMMAND", colors.peach },
            ["cv"] = { "COMMAND", colors.peach },
            ["ce"] = { "COMMAND", colors.peach },
            ["r"] = { "PROMPT", colors.teal },
            ["rm"] = { "MORE", colors.teal },
            ["r?"] = { "CONFIRM", colors.mauve },
            ["!"] = { "SHELL", colors.green },
        },
        view = {
            lsp = {
                progress = true,        -- if true the status bar will display an lsp progress indicator
                name = false,           -- if true the status bar will display the lsp servers name, otherwise it will display the text "Lsp"
                exclude_lsp_names = {}, -- lsp server names that should not be displayed when name is set to true
                separator = "|",        -- the separator used when there are multiple lsp servers
            },
        }
    })

    local feline = require("feline")
    feline.setup {
        components = require("catppuccin.groups.integrations.feline").get(),
    }
end
