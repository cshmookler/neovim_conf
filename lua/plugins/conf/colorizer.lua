return function()
    local colorizer = require("colorizer")
    colorizer.setup(
        {
            css = { css = true },
            scss = {},
            html = {},
            javascript = {},
        },
        {
            RGB      = true,         -- #RGB hex codes
            RRGGBB   = true,         -- #RRGGBB hex codes
            names    = false,        -- "Name" codes like Blue
            RRGGBBAA = false,        -- #RRGGBBAA hex codes
            rgb_fn   = false,        -- CSS rgb() and rgba() functions
            hsl_fn   = false,        -- CSS hsl() and hsla() functions
            css      = false,        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn   = false,        -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Available color modes: foreground, background
            mode     = 'background', -- Set the display mode.
        })
end
