return function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    local bufferline = require("bufferline")
    bufferline.setup({
        options = {
            mode = "tabs",                       -- "buffers" | "tabs"
            style_preset = bufferline.style_preset.default,
            themable = true,                     -- true | false
            numbers = "none",                    -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
            close_command = "bdelete! %d",       -- string | function | false
            right_mouse_command = "bdelete! %d", -- string | function | false
            left_mouse_command = "buffer %d",    -- string | function | false
            middle_mouse_command = nil,          -- string | function | false
            indicator = {
                icon = nil,                      -- "▎" | nil
                style = "none",                  -- "icon" | "underline" | "none"
            },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 18,
            max_prefix_length = 15,               -- prefix used when a buffer is de-duplicated
            truncate_names = true,                -- whether or not tab names should be truncated
            tab_size = 18,
            diagnostics = "nvim_lsp",             -- false | "nvim_lsp" | "coc",
            diagnostics_update_in_insert = false, -- true | false
            color_icons = true,                   -- true | false
            show_buffer_icons = true,             -- disable filetype icons for buffers
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = false,
            show_duplicate_prefix = true,    -- whether to show duplicate buffer prefix
            duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
            persist_buffer_sort = true,      -- whether or not custom sorted buffers should persist
            move_wraps_at_ends = false,      -- whether or not the move command "wraps" at the first or last position
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { '|', '|' }
            separator_style = "thin",       -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            enforce_regular_tabs = true,    -- false | true,
            always_show_bufferline = true,  -- true | false,
            auto_toggle_bufferline = false, -- true | false,
            hover = {
                enabled = true,
                delay = 200,
                reveal = { 'close' }
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get({
                styles = { "italic", "bold" },
                custom = {
                    all = {
                        ---@diagnostic disable-next-line: undefined-field, need-check-nil
                        fill = { bg = mocha.bg },
                    },
                    mocha = {
                        ---@diagnostic disable-next-line: need-check-nil
                        background = { fg = mocha.text },
                    },
                    latte = {
                        ---@diagnostic disable-next-line: undefined-field, need-check-nil
                        background = { fg = mocha.fg },
                    },
                },
            }),
        }
    })
end
