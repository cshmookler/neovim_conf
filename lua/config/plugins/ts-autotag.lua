return {
    "windwp/nvim-ts-autotag",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",       
    },
    lazy = false,
    opts = {
        opts = {
            enable_close = true,  -- Auto close tags
            enable_rename = true,  -- Auto rename pairs of tags
            enable_close_on_slash = false,  -- Auto close on trailing
        },
    },
}
