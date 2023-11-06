return function()
    local bufferline = require("bufferline")
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    bufferline.setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get({
            styles = { "italic", "bold" },
            custom = {
                all = {
                    fill = { bg = mocha.bg },
                },
                mocha = {
                    background = { fg = mocha.text },
                },
                latte = {
                    background = { fg = mocha.fg },
                },
            },
        }),
    })
end
