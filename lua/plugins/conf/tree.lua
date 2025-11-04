return function()
    local tree = require("nvim-tree")
    tree.setup({
        on_attach = function(bufnr) -- or "default"
            local nvim_tree_api = require("nvim-tree.api")
            -- nvim_tree_api.config.mappings.default_on_attach(bufnr)

            nbufnoremap("<C-h>", function()
                nvim_tree_api.node.open.horizontal()
                nvim_tree_api.tree.focus()
            end, bufnr, "Open file in horizontal split")

            nbufnoremap("<C-l>", function()
                nvim_tree_api.node.open.vertical()
                nvim_tree_api.tree.focus()
            end, bufnr, "Open file in vertical split")

            nbufnoremap("<C-s>", function()
                vim.cmd.tabprevious()
                nvim_tree_api.tree.focus()
            end, bufnr, "Goto previous tab")

            nbufnoremap("<C-f>", function()
                vim.cmd.tabnext()
                nvim_tree_api.tree.focus()
            end, bufnr, "Goto next tab")

            nbufnoremap("f", function()
                local node = nvim_tree_api.tree.get_node_under_cursor()
                if node.name == ".." then
                    vim.cmd.tcd("..")
                else
                    nvim_tree_api.node.open.edit()
                    nvim_tree_api.tree.focus()
                end
            end, bufnr, "Open file in pane")

            nbufnoremap("v", function()
                nvim_tree_api.node.open.tab()
                nvim_tree_api.tree.focus()
            end, bufnr, "Open file in new tab")

            nbufnoremap("F", function()
                local node = nvim_tree_api.tree.get_node_under_cursor()
                if node.type == "directory" then
                    vim.cmd.tcd(node.absolute_path)
                end
            end, bufnr, "Change root to node")

            nbufnoremap("R", function()
                nvim_tree_api.tree.reload()
            end, bufnr, "Reload tree")

            nbufnoremap("i", function()
                nvim_tree_api.node.show_info_popup()
            end, bufnr, "Show info popup")

            nbufnoremap("y", function()
                local node = nvim_tree_api.tree.get_node_under_cursor()
                vim.fn.setreg("+", node.name)
            end, bufnr, "Copy name of file or directory")

            nbufnoremap("Y", function()
                local node = nvim_tree_api.tree.get_node_under_cursor()
                vim.fn.setreg("+", node.absolute_path)
            end, bufnr, "Copy absolute path to file or directory")

            nbufnoremap("r", function()
                nvim_tree_api.fs.rename()
            end, bufnr, "Rename file or directory")

            nbufnoremap("a", function()
                nvim_tree_api.fs.create()
            end, bufnr, "Create new file or directory")

            nbufnoremap("c", function()
                nvim_tree_api.marks.toggle()
                nvim_tree_api.fs.copy.node()
            end, bufnr, "Select a file or directory")

            nbufnoremap("p", function()
                nvim_tree_api.fs.paste()
                nvim_tree_api.marks.clear()
                nvim_tree_api.fs.clear_clipboard()
            end, bufnr, "Copy selected files or directories to another directory")

            nbufnoremap("m", function()
                nvim_tree_api.marks.bulk.move()
                nvim_tree_api.marks.clear()
                nvim_tree_api.fs.clear_clipboard()
            end, bufnr, "Move selected files or directories to another directory")

            nbufnoremap("d", function()
                if #nvim_tree_api.marks.list() == 0 then
                    nvim_tree_api.fs.trash()
                else
                    nvim_tree_api.marks.bulk.trash()
                end
                nvim_tree_api.marks.clear()
                nvim_tree_api.fs.clear_clipboard()
            end, bufnr, "Trash selected files or directories")

            nbufnoremap("D", function()
                if #nvim_tree_api.marks.list() == 0 then
                    nvim_tree_api.fs.remove()
                else
                    nvim_tree_api.marks.bulk.delete()
                end
                nvim_tree_api.marks.clear()
                nvim_tree_api.fs.clear_clipboard()
            end, bufnr, "Delete selected files or directories")

            nbufnoremap("x", function()
                nvim_tree_api.marks.clear()
                nvim_tree_api.fs.clear_clipboard()
            end, bufnr, "Deselect all files and directories")
        end,
        hijack_cursor = false,
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = false,
        respect_buf_cwd = false,
        select_prompts = false,
        sort = {
            sorter = "name",
            folders_first = true,
            files_first = false,
        },
        view = {
            centralize_selection = false,
            cursorline = true,
            debounce_delay = 15,
            side = "left",
            preserve_window_proportions = true,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
            width = nil,
            float = {
                enable = true,
                quit_on_focus_loss = true,
                open_win_config = function()
                    local ui = vim.api.nvim_list_uis()[1]
                    return {
                        relative = "editor",
                        border = "single", -- none, single, double, rounded, solid, or shadow
                        width = math.floor(ui.width * 0.5),
                        height = math.floor(ui.height * 0.5),
                        row = math.floor(ui.height * 0.25),
                        col = math.floor(ui.width * 0.25),
                        -- width = math.floor(ui.width * 0.75),
                        -- height = math.floor(ui.height * 0.75),
                        -- row = math.floor(ui.height * 0.125),
                        -- col = math.floor(ui.width * 0.125),
                    }
                end,
            },
        },
        renderer = {
            add_trailing = false,
            group_empty = false,
            full_name = false,
            root_folder_label = ":~:s?$?/..?",
            indent_width = 4,
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            symlink_destination = true,
            highlight_git = false,
            highlight_diagnostics = false,
            highlight_opened_files = "none",
            highlight_modified = "none",
            highlight_bookmarks = "none",
            highlight_clipboard = "name",
            indent_markers = {
                enable = false,
                inline_arrows = true,
                icons = {
                    corner = "└",
                    edge = "│",
                    item = "│",
                    bottom = "─",
                    none = " ",
                },
            },
            icons = {
                web_devicons = {
                    file = {
                        enable = true,
                        color = true,
                    },
                    folder = {
                        enable = false,
                        color = true,
                    },
                },
                git_placement = "signcolumn",
                modified_placement = "signcolumn",
                diagnostics_placement = "signcolumn",
                bookmarks_placement = "signcolumn",
                padding = " ",
                symlink_arrow = " ➛ ",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                    modified = true,
                    diagnostics = true,
                    bookmarks = true,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    bookmark = "󰆤",
                    modified = "●",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "U",
                        staged = "S",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = false,
            update_root = false,
            ignore_list = {},
        },
        system_open = {
            cmd = "",
            args = {},
        },
        git = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            disable_for_dirs = {},
            timeout = 400,
            cygwin_support = false,
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            debounce_delay = 50,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        modified = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
        },
        filters = {
            git_ignored = false,
            dotfiles = false,
            git_clean = false,
            no_buffer = false,
            custom = {},
            exclude = {},
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = true,
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
            ignore_dirs = {},
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            expand_all = {
                max_folder_discovery = 300,
                exclude = {},
            },
            file_popup = {
                open_win_config = {
                    col = 1,
                    row = 1,
                    relative = "cursor",
                    border = "single",
                    style = "minimal",
                },
            },
            open_file = {
                quit_on_open = false,
                eject = true,
                resize_window = true,
                window_picker = {
                    enable = true,
                    picker = "default",
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
            remove_file = {
                close_window = true,
            },
        },
        trash = {
            cmd = "gio trash",
        },
        tab = {
            sync = {
                open = false,
                close = false,
                ignore = {},
            },
        },
        notify = {
            threshold = vim.log.levels.ERROR,
            absolute_path = true,
        },
        help = {
            sort_by = "key",
        },
        ui = {
            confirm = {
                remove = true,
                trash = true,
                default_yes = false,
            },
        },
        experimental = {},
        log = {
            enable = false,
            truncate = false,
            types = {
                all = false,
                config = false,
                copy_paste = false,
                dev = false,
                diagnostics = false,
                git = false,
                profile = false,
                watcher = false,
            },
        },
    })
end
