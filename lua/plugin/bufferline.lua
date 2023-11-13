return function()
    local bufferline = require("bufferline")
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    ---@diagnostic disable-next-line: missing-fields
    bufferline.setup({
        ---@diagnostic disable-next-line: missing-fields
        options = {
            -- :h bufferline-configuration
            mode = "tabs",
            numbers = "none",
            diagnostics = "nvim_lsp",
            separator_style = "slant",
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
