return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        "aznhe21/actions-preview.nvim",
        "elentok/format-on-save.nvim",
        "mfussenegger/nvim-lint",
    },
    config = function()
        vim.diagnostic.config({
            underline = true,
            virtual_text = false,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = 'E',
                    [vim.diagnostic.severity.WARN]  = 'W',
                    [vim.diagnostic.severity.INFO]  = 'I',
                    [vim.diagnostic.severity.HINT]  = 'H',
                }
            },
            update_in_insert = true,
            severity_sort = true,
        })

        local format_on_save = require("format-on-save")
        local formatters = require("format-on-save.formatters")
        format_on_save.setup({
            formatter_by_ft = {
                python = {
                    formatters.black,
                    formatters.shell({
                        cmd = { "usort", "format", "%" },
                        tempfile = "random",
                    }),
                },
                xxd = {}, -- Do NOT format hex dumps
            },
            fallback_formatter = {
                formatters.lsp,
            },
            run_with_sh = false,
        })

        local actions_preview = require("actions-preview")
        actions_preview.setup()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local utils = require("config.utils")

        local lsp_autocmds_group = "custom_lsp_autocmds"
        vim.api.nvim_create_augroup(lsp_autocmds_group, {})

        utils.nnoremap("gm", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Goto next diagnostic")
        utils.nnoremap("gn", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Goto previous diagnostic")
        utils.nnoremap("gB", vim.diagnostic.setloclist, "Goto diagnostic list")
        utils.nnoremap("gf", vim.diagnostic.open_float, "Open floating diagnostic message")

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                utils.nbufnoremap("gd", ":split<CR>:lua vim.lsp.buf.definition()<CR>", args.buf, "Goto definition")
                utils.nbufnoremap("gD", ":split<CR>:lua vim.lsp.buf.declaration()<CR>", args.buf, "Goto declaration")
                utils.nbufnoremap("gt", ":split<CR>:lua vim.lsp.buf.type_definition()<CR>", args.buf,
                    "Goto type defition")
                utils.nbufnoremap("gI", ":split<CR>:lua vim.lsp.buf.implementation()<CR>", args.buf,
                    "Goto implementation")
                utils.nbufnoremap("gr", ":split<CR>:lua vim.lsp.buf.references()<CR>", args.buf, "Goto references")
                utils.nbufnoremap("<Leader>r", vim.lsp.buf.rename, args.buf, "Rename")
                utils.nbufnoremap("<Leader>c", actions_preview.code_actions, args.buf, "Code action")
                utils.nbufnoremap("Y", vim.lsp.buf.hover, args.buf, "Hover")
                utils.nbufnoremap("<Leader>F", vim.lsp.buf.format, args.buf, "Format")
            end,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
            callback = function(args)
                vim.api.nvim_clear_autocmds({
                    buffer = args.buf,
                    group = lsp_autocmds_group,
                })
            end,
        })

        local lsp_enable = function(name, opts)
            if opts == nil then
                opts = {}
            end
            opts.capabilities = capabilities
            vim.lsp.config(name, opts)
            vim.lsp.enable(name)
        end

        lsp_enable('html')   -- vscode-html-languageserver
        lsp_enable('jsonls') -- vscode-json-languageserver
        lsp_enable('cssls')  -- vscode-css-languageserver
        lsp_enable('yamlls') -- yaml-language-server
        lsp_enable('ts_ls')  -- typescript-language-server
        lsp_enable('clangd') -- clang
        lsp_enable('lua_ls', {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace",
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })                                 -- lua-language-server
        lsp_enable('vimls')                -- vim-language-server
        lsp_enable('jedi_language_server') -- jedi-language-server
        lsp_enable('bashls')               -- bash-language-server
        lsp_enable('rust_analyzer')        -- rust-analyzer
        vim.lsp.config('texlab', {         -- texlab
            -- -- Using the capabilities given by nvim-cmp appears to break texlab.
            -- capabilities = capabilities,
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        })
        vim.lsp.enable('texlab')
        lsp_enable('csharp_ls')    -- csharp-ls
        lsp_enable('openscad_lsp') -- openscad-lsp
        lsp_enable('verible')      -- verible-bin
        lsp_enable('gopls')        -- gopls

        local lint = require("lint")
        lint.linters_by_ft = {
            python = { "mypy", "flake8" }
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
