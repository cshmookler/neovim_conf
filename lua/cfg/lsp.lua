local WIDE_HEIGHT = 40

return function(lsp_servers)
    local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-y>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
    end

    local mason = require("mason")
    mason.setup(require("opt.mason"))

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup(
        require("opt.mason_lspconfig")(vim.tbl_keys(lsp_servers))
    )

    local neodev = require("neodev")
    neodev.setup(require("opt.neodev"))

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    local lspconfig = require("lspconfig")

    mason_lspconfig.setup_handlers({
        function(server_name)
            if lsp_servers[server_name]["autosetup"] == false then
                return
            end
            -- print("loading server: " .. server_name)
            lspconfig[server_name].setup(vim.tbl_extend("force", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = lsp_servers[server_name]["lsp_settings"] or {},
                filetypes = (lsp_servers[server_name]["lsp_settings"] or {}).filetypes,
            }, lsp_servers[server_name]["lspconfig_settings"] or {}))
        end,
    })

    -- print("loading server: " .. "swift_mesonls")
    lspconfig["swift_mesonls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = lsp_servers["swift_mesonls"],
        filetypes = (lsp_servers["swift_mesonls"] or {}).filetypes,
    })

    -- local jdtls_project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local jdtls_config = {
        cmd = {
            "jdtls",
            "-configuration",
            vim.fn.expand("$HOME/.cache/jdtls/config"),
            "-data",
            -- vim.fn.expand("$HOME/.cache/jdtls/workspace"),
            vim.fn.getcwd(),
        },
        -- cmd = { "jdtls" },
        root_dir = vim.fn.getcwd(),
    }
    require("jdtls").start_or_attach(jdtls_config)

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    -- luasnip.lazy_load()
    luasnip.config.setup()

    cmp.setup({

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        performance = {
            debounce = 60,
            throttle = 30,
            fetching_timeout = 500,
            confirm_resolve_timeout = 80,
            async_budget = 1,
            max_view_entries = 200,
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
                border = { "", "", "", "", "", "", "", "" },
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                scrolloff = 0,
                col_offset = 0,
                side_padding = 1,
                scrollbar = true,
            },
            documentation = {
                max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
                max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
                border = { "", "", "", "", "", "", "", "" },
                winhighlight = "FloatBorder:NormalFloat",
            }
        },

        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
        }),

        formatting = {
            fields = { "abbr", "kind", "menu" },
            -- format = function(entry, vim_item)
            --     vim_item.kind = string.format('%s %s', cmp_kinds[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            --     -- Source
            --     vim_item.menu = ({
            --         buffer = "[Buffer]",
            --         nvim_lsp = "[LSP]",
            --         luasnip = "[LuaSnip]",
            --         nvim_lua = "[Lua]",
            --         latex_symbols = "[LaTeX]",
            --     })[entry.source.name]
            --     return vim_item
            -- end,
            expandable_indicator = true,
        },

        sources = cmp.config.sources({
            {
                name = 'nvim_lsp',
                entry_filter = function(entry, _)
                    return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
                end,
            },
            {
                name = 'luasnip'
            },
            {
                name = 'buffer',
                entry_filter = function(entry, _)
                    return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
                end,
            },
        }),

    })

    -- Set configuration for specific filetype.
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    --   }, {
    --     { name = 'buffer' },
    --   })
    -- })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })
end
