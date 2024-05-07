return function()
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = {
            highlight_while_line = false,
            only_current_line = false,
        },
    })

    local dictionary = require("cmp_dictionary")
    dictionary.setup({ paths = { "/etc/xdg/nvim/en.dict" } })

    local cmp = require("cmp")
    -- local cmp_context = require("cmp.config.context")
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
                    nvim_lsp = item.kind,
                    nvim_lsp_signature_help = "Signature",
                    luasnip = "Snippet",
                    calc = "Calc",
                    emoji = "Emoji",
                    nerdfont = "Nerd Font Icon",
                    buffer = "Buffer",
                    dictionary = "Dictionary",
                }
                item.kind = kind[entry.source.name]
                return item
            end,
            expandable_indicator = true,
        },

        sources = {
            {
                name = "nvim_lsp_signature_help",
                keyword_length = 1,
                max_item_count = 15,
            },
            {
                name = "nvim_lsp",
                keyword_length = 1,
                max_item_count = 10,
                entry_filter = function(entry, _)
                    return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
                end,
            },
            {
                name = "luasnip",
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
                keyword_length = 1,
                max_item_count = 2,
            },
            {
                name = "emoji",
                keyword_length = 1,
                max_item_count = 10,
            },
            {
                name = "nerdfont",
                keyword_length = 1,
                max_item_count = 10,
            },
            {
                name = "dictionary",
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

    require("util.keymap")

    nnoremap("gm", vim.diagnostic.goto_next, "Goto next diagnostic")
    nnoremap("gn", vim.diagnostic.goto_prev, "Goto previous diagnostic")
    nnoremap("gB", vim.diagnostic.setloclist, "Goto diagnostic list")
    nnoremap("gf", vim.diagnostic.open_float, "Open floating diagnostic message")

    local lsp = {} -- Forward declaration for reference in on_attach.

    local on_attach = function(client, bufnr)
        nnoremap("gd", vim.lsp.buf.definition, "Goto definition")
        nnoremap("gD", vim.lsp.buf.declaration, "Goto declaration")
        nnoremap("gt", vim.lsp.buf.type_definition, "Goto type defition")
        nnoremap("gI", vim.lsp.buf.implementation, "Goto implementation")
        nnoremap("gr", vim.lsp.buf.references, "Goto references")
        nnoremap("<Leader>r", vim.lsp.buf.rename, "Rename")
        nnoremap("<Leader>c", ":CodeActionMenu<CR>", "Code action") -- vim.lsp.buf.code_action
        nnoremap("Y", vim.lsp.buf.hover, "Hover")

        -- Treesitter highlighting
        vim.treesitter.start(bufnr)

        if client.server_capabilities.inlayHintProvider then
            -- Inlay hints
            vim.lsp.inlay_hint.enable(bufnr, true)
        end

        if lsp[client.name].format and client.server_capabilities.documentOnTypeFormattingProvider then
            -- Format command and format on save.
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                vim.lsp.buf.format()
            end, {})
            vim.api.nvim_buf_create_user_command(bufnr, "FormatOnSaveEnable", function()
                vim.g._format_on_save = true
                print("enabled")
            end, {})
            vim.api.nvim_buf_create_user_command(bufnr, "FormatOnSaveDisable", function()
                vim.g._format_on_save = false
                print("disabled")
            end, {})
            if lsp[client.name].format_on_save then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        if not vim.g._format_on_save then
                            return
                        end
                        local view = vim.fn.winsaveview()
                        vim.lsp.buf.format({ bufnr = bufnr })
                        ---@diagnostic disable-next-line: param-type-mismatch
                        vim.fn.winrestview(view)
                    end,
                })
            end
        end
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local neodev = require("neodev")
    neodev.setup({
        lspconfig = false,
    })

    lsp = {

        ["lua-language-server"] = {
            name = "lua-language-server",
            lang = "lua",
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            auto_start = true,
            before_init = require("neodev.lsp").before_init,
            root_dir = vim.fn.getcwd(),
            format = true,
            format_on_save = true,
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            -- }, { upward = true })[1] or vim.fn.getcwd()),
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
            on_attach = on_attach,
            capabilities = capabilities,
        },

        ["clangd"] = {
            name = "clangd",
            lang = "cpp",
            cmd = { "clangd", --[[ "--header-insertion=never" --]] },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            auto_start = true,
            root_dir = vim.fn.getcwd(),
            format = true,
            format_on_save = true,
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            --     ".clangd",
            --     ".clang-format",
            --     ".clang-tidy",
            -- }, { upward = true })[1] or vim.fn.getcwd()),
            on_attach = on_attach,
            capabilities = capabilities,
        },

        ["Swift-MesonLSP"] = {
            name = "Swift-MesonLSP",
            lang = "meson",
            cmd = { "Swift-MesonLSP", "--lsp" },
            filetypes = { "meson" },
            auto_start = true,
            root_dir = vim.fn.getcwd(),
            format = false,
            format_on_save = false,
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            -- }, { upward = true })[1] or vim.fn.getcwd()),
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = bufnr,
                    command = "silent ! muon fmt -c muon_fmt.ini -i %",
                })
            end,
            capabilities = capabilities,
        },

        ["pyright"] = {
            name = "pyright",
            lang = "python",
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            auto_start = true,
            root_dir = vim.fn.getcwd(),
            format = false,
            format_on_save = false,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                    },
                },
            },
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                    buffer = bufnr,
                    command = "silent ! black --line-length 80 % ",
                })
            end,
            capabilities = capabilities,
        },

        ["jdtls"] = {
            name = "jdtls",
            lang = "java",
            cmd = {
                "jdtls",
                "-configuration",
                vim.fn.expand("$HOME/.cache/jdtls/config"),
                "-data",
                vim.fn.expand("$HOME/.cache/jdtls/workspace"),
            },
            init_options = {
                jvm_args = {},
                workspace = vim.fn.expand("$HOME/.cache/jdtls/workspace")
            },
            filetypes = { "java" },
            root_dir = vim.fn.getcwd(),
            format = true,
            format_on_save = true,
            on_attach = on_attach,
            capabilities = capabilities,
        },

        ["bash-language-server"] = {
            name = "bash-language-server",
            lang = "bash",
            cmd = {
                "bash-language-server",
                "start",
            },
            filetypes = { "sh" },
            auto_start = true,
            root_dir = vim.fn.getcwd(),
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- vim.api.nvim_create_autocmd("BufWritePost", {
                --     buffer = bufnr,
                --     callback = function()
                --         local view = vim.fn.winsaveview()
                --         vim.cmd("silent %! shfmt -i " .. vim.o.shiftwidth .. " %")
                --         ---@diagnostic disable-next-line: param-type-mismatch
                --         vim.fn.winrestview(view)
                --     end,
                -- })
            end,
            capabilities = capabilities,
        },
    }

    for _, config in pairs(lsp) do
        if not config.auto_start then
            goto continue
        end
        local start_or_attach = function()
            local client = vim.lsp.start(config)
            if not client then
                return
            end
            vim.lsp.buf_attach_client(0, client)
        end
        vim.api.nvim_create_autocmd("FileType", {
            pattern = config.filetypes,
            callback = start_or_attach,
        })
        vim.api.nvim_create_user_command("LspStart" .. config.lang, start_or_attach, {})
        ::continue::
    end

    local start_or_attach_jdtls = function()
        require("jdtls").start_or_attach(lsp["jdtls"])
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = lsp["jdtls"].filetypes,
        callback = start_or_attach_jdtls,
    })
    vim.api.nvim_create_user_command("LspStart" .. lsp["jdtls"].lang, start_or_attach_jdtls, {})

    local fidget = require("fidget")
    fidget.setup()

    vim.g.code_action_menu_show_details = false
    vim.g.code_action_menu_show_diff = true
    vim.g.code_action_menu_show_action_kind = true

    -- local lightbulb = require("nvim-lightbulb")
    -- lightbulb.setup({
    --     autocmd = { enabled = true },
    --     sign = {
    --         enabled = true,
    --     },
    -- })
end
