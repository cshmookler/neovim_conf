return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "weilbith/nvim-code-action-menu",
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

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local utils = require("config.utils")

        utils.nnoremap("gm", vim.diagnostic.goto_next, "Goto next diagnostic")
        utils.nnoremap("gn", vim.diagnostic.goto_prev, "Goto previous diagnostic")
        utils.nnoremap("gB", vim.diagnostic.setloclist, "Goto diagnostic list")
        utils.nnoremap("gf", vim.diagnostic.open_float, "Open floating diagnostic message")

        local lsp_autocmds_group = "custom_lsp_autocmds"
        vim.api.nvim_create_augroup(lsp_autocmds_group, {})

        local on_attach = function(args)
            local bufnr = args.buf

            utils.nbufnoremap("gd", vim.lsp.buf.definition, bufnr, "Goto definition")
            utils.nbufnoremap("gD", vim.lsp.buf.declaration, bufnr, "Goto declaration")
            utils.nbufnoremap("gt", vim.lsp.buf.type_definition, bufnr, "Goto type defition")
            utils.nbufnoremap("gI", vim.lsp.buf.implementation, bufnr, "Goto implementation")
            utils.nbufnoremap("gr", vim.lsp.buf.references, bufnr, "Goto references")
            utils.nbufnoremap("<Leader>r", vim.lsp.buf.rename, bufnr, "Rename")
            utils.nbufnoremap("<Leader>c", ":CodeActionMenu<CR>", bufnr, "Code action") -- vim.lsp.buf.code_action
            utils.nbufnoremap("Y", vim.lsp.buf.hover, bufnr, "Hover")
            utils.nbufnoremap("<Leader>F", vim.lsp.buf.format, bufnr, "Format")
        end

        local on_detach = function(args)
            local bufnr = args.buf

            vim.api.nvim_clear_autocmds({
                buffer = bufnr,
                group = lsp_autocmds_group,
            })
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = on_attach,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
            callback = on_detach,
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

        vim.g.code_action_menu_show_details = false
        vim.g.code_action_menu_show_diff = true
        vim.g.code_action_menu_show_action_kind = true
    end,
}
