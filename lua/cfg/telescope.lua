return function()
    local telescope = require('telescope')
    telescope.setup({
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
                i = {
                    -- map actions.which_key to <C-h> (default: <C-/>)
                    -- actions.which_key shows the mappings for your picker,
                    -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                    -- ["<C-h>"] = "which_key"
                    ["<C-u>"] = false,
                    ["<C-d>"] = false,
                }
            }
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
        }
    })

    -- Setup fuzzy finding for telescope.
    telescope.load_extension("fzf")

    -- Custom keybinds.
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "[F]ind [G]it Files" })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "[F]ind [W]ord" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "[F]ind [H]elp" })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = "[F]ind [R]esume" })
end

