return function()
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

    local cmp = require("cmp")

    local luasnip = require("luasnip")
    luasnip.config.setup()

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        view = {
            entries = {
                name = "custom",
                selection_order = "top_down",
            },
            docs = {
                auto_open = true,
            },
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        formatting = {
            fields = { "abbr", "kind" },
            format = function(entry, item)
                local kind = {
                    ["nvim_lsp"] = item.kind,
                    ["nvim_lsp_signature_help"] = "Signature",
                    ["luasnip"] = "Snippet",
                    ["calc"] = "Calc",
                    ["emoji"] = "Emoji",
                    ["nerdfont"] = "Nerd Font Icon",
                    ["buffer"] = "Buffer",
                    ["dictionary"] = "Dictionary",
                }
                item.kind = kind[entry.source.name]
                return item
            end,
            expandable_indicator = true,
        },
        sources = {
            {
                name = "nvim_lsp_signature_help",
                group_index = 1,
                priority = 100,
                keyword_length = 0,
            },
            {
                name = "nvim_lsp",
                group_index = 2,
                priority = 90,
                keyword_length = 0,
                entry_filter = function(entry, _)
                    return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
                end,
            },
            {
                name = "luasnip",
                group_index = 2,
                priority = 80,
                keyword_length = 2,
                max_item_count = 1,
            },
            -- {
            --     name = "buffer",
            --     keyword_length = 2,
            --     max_item_count = 3,
            -- },
            {
                name = "calc",
                group_index = 3,
                priority = 50,
                keyword_length = 1,
                max_item_count = 2,
            },
            {
                name = "emoji",
                group_index = 3,
                priority = 20,
                keyword_length = 1,
                max_item_count = 10,
            },
            {
                name = "nerdfont",
                group_index = 3,
                priority = 20,
                keyword_length = 1,
                max_item_count = 10,
            },
            {
                name = "dictionary",
                group_index = 4,
                priority = 10,
                keyword_length = 2,
                max_item_count = 5,
            },
        },
        mapping = {
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-Space>"] = cmp.mapping(function(_)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                else
                    cmp.complete()
                end
            end, { "i", "s" }),
            ["<C-n>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
    })

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = "nvim_lsp_document_symbol",
                max_item_count = 10,
            },
            -- {
            --     name = "buffer",
            --     max_item_count = 5,
            -- },
        }),
    })

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup.cmdline({ ":" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = "path",
                max_item_count = 10,
            },
            {
                name = "cmdline",
                max_item_count = 10,
            },
        })
    })

    local dictionary = require("cmp_dictionary")
    dictionary.setup({
        paths = { "~/.local/share/nvim/dict" },
        first_case_insensitive = true,
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

    local neodev = require("neodev")
    neodev.setup {}

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("util.key_map")

    nnoremap("gm", vim.diagnostic.goto_next, "Goto next diagnostic")
    nnoremap("gn", vim.diagnostic.goto_prev, "Goto previous diagnostic")
    nnoremap("gB", vim.diagnostic.setloclist, "Goto diagnostic list")
    nnoremap("gf", vim.diagnostic.open_float, "Open floating diagnostic message")

    local lsp_autocmds_group = "custom_lsp_autocmds"
    vim.api.nvim_create_augroup(lsp_autocmds_group, {})

    local on_attach = function(args)
        local bufnr = args.buf

        nbufnoremap("gd", vim.lsp.buf.definition, bufnr, "Goto definition")
        nbufnoremap("gD", vim.lsp.buf.declaration, bufnr, "Goto declaration")
        nbufnoremap("gt", vim.lsp.buf.type_definition, bufnr, "Goto type defition")
        nbufnoremap("gI", vim.lsp.buf.implementation, bufnr, "Goto implementation")
        nbufnoremap("gr", vim.lsp.buf.references, bufnr, "Goto references")
        nbufnoremap("<Leader>r", vim.lsp.buf.rename, bufnr, "Rename")
        nbufnoremap("<Leader>c", ":CodeActionMenu<CR>", bufnr, "Code action") -- vim.lsp.buf.code_action
        nbufnoremap("Y", vim.lsp.buf.hover, bufnr, "Hover")
        nbufnoremap("<Leader>F", vim.lsp.buf.format, bufnr, "Format")
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

    local lspconfig = require("lspconfig")

    lspconfig.html.setup { -- vscode-html-languageserver
        capabilities = capabilities,
    }
    lspconfig.jsonls.setup { -- vscode-json-languageserver
        capabilities = capabilities,
    }
    lspconfig.cssls.setup { -- vscode-css-languageserver
        capabilities = capabilities,
    }
    lspconfig.yamlls.setup { -- yaml-language-server
        capabilities = capabilities,
    }
    lspconfig.ts_ls.setup { -- typescript-language-server
        capabilities = capabilities,
    }
    lspconfig.clangd.setup { -- clang
        capabilities = capabilities,
    }
    lspconfig.lua_ls.setup { -- lua-language-server
        capabilities = capabilities,
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
    }
    lspconfig.vimls.setup { -- vim-language-server
        capabilities = capabilities,
    }
    lspconfig.jedi_language_server.setup { -- jedi-language-server
        capabilities = capabilities,
    }
    lspconfig.bashls.setup { -- bash-language-server
        capabilities = capabilities,
    }
    lspconfig.rust_analyzer.setup { -- rust_analyzer
        capabilities = capabilities,
    }
    lspconfig.texlab.setup { -- texlab
        -- -- Using the capabilities given by nvim-cmp appears to break texlab.
        -- capabilities = capabilities,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    }
    lspconfig.csharp_ls.setup { -- csharp-ls
        capabilities = capabilities,
    }
    lspconfig.openscad_lsp.setup { -- openscad-lsp
        capabilities = capabilities,
    }
    lspconfig.verible.setup { -- verible-bin
        capabilities = capabilities,
    }

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
end
