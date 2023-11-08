return function()
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = {
            highlight_while_line = false,
            only_current_line = true,
        },
    })

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup()

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
            completion = {
                scrolloff = 5,
                col_offset = 0,
                side_padding = 1,
                scrollbar = true,
            },
            documentation = {},
        },

        formatting = {
            -- fields = { "menu", "abbr", "kind" },
            fields = { "abbr", "kind", "menu" },
            expandable_indicator = true,
        },

        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "nvim_lsp_signature_help" },
            { name = "calc" },
            { name = "emoji" },
            {
                name = "buffer",
                entry_filter = function(entry, _)
                    return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
                end,
            },
        },

        mapping = {
            ["<C-p>"] = function() end,
            ["<C-n>"] = function() end,
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-u>"] = cmp.mapping.scroll_docs(4),
            -- ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-Space>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
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

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            -- { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline({ ":" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        })
    })

    require("util.keymap")

    nnoremap("gm", vim.diagnostic.goto_next, "Goto next diagnostic")
    nnoremap("gn", vim.diagnostic.goto_prev, "Goto previous diagnostic")
    nnoremap("gbb", vim.diagnostic.setloclist, "Goto diagnostic list")
    nnoremap("gf", vim.diagnostic.open_float, "Open floating diagnostic message")

    local on_attach = function(client, bufnr)
        nnoremap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nnoremap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nnoremap("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Defition")
        nnoremap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nnoremap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        nnoremap("<Leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nnoremap("<Leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nnoremap("K", vim.lsp.buf.hover, "[H]over")

        -- Inlay hints
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
        end
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local neodev = require("neodev")
    neodev.setup({
        lspconfig = false,
    })

    local lsp = {

        {
            name = "lua-language-server",
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            before_init = require("neodev.lsp").before_init,
            root_dir = vim.loop.cwd(),
            format_on_save = true,
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            -- }, { upward = true })[1] or vim.loop.cwd()),
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

        {
            name = "clangd",
            cmd = { "clangd" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = vim.loop.cwd(),
            format_on_save = true,
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            --     ".clangd",
            --     ".clang-format",
            --     ".clang-tidy",
            --     "compile_commands.json",
            -- }, { upward = true })[1] or vim.loop.cwd()),
            on_attach = on_attach,
            capabilities = capabilities,
        },

        {
            name = "Swift-MesonLSP",
            cmd = { "Swift-MesonLSP", "--lsp" },
            filetypes = { "meson" },
            root_dir = vim.loop.cwd(),
            -- root_dir = vim.fs.dirname(vim.fs.find({
            --     ".git",
            -- }, { upward = true })[1] or vim.loop.cwd()),
            on_attach = on_attach,
            capabilities = capabilities,
        },

    }

    for _, config in pairs(lsp) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = config.filetypes,
            callback = function()
                local client = vim.lsp.start(config)
                if not client then
                    return
                end
                vim.lsp.buf_attach_client(0, client)

                -- Format command and format on save.
                vim.api.nvim_buf_create_user_command(0, "Format", function()
                    vim.lsp.buf.format()
                end, {})
                if config.format_on_save then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = 0,
                        callback = function()
                            local view = vim.fn.winsaveview()
                            vim.lsp.buf.format()
                            vim.fn.winrestview(view)
                        end,
                    })
                end
            end,
        })
    end

    local jdtls_config = {
        name = "jdtls",
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
        on_attach = on_attach,
        capabilities = capabilities,
    }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = jdtls_config.filetypes,
        callback = function()
            require("jdtls").start_or_attach(jdtls_config)
        end,
    })

    local fidget = require("fidget")
    fidget.setup()
end
