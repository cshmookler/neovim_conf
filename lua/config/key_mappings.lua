require("util.key_map")

-- Move by visual lines instead of actual lines.
nvnoremap("j", "gj", "Move down by visual line")
nvnoremap("k", "gk", "Move up by one visual line")

-- Fast vertical movement
nvnoremap("H", "3b", "Three words left")
-- nvnoremap("J", "3j", "Three lines down")
-- nvnoremap("K", "3k", "Three lines up")
nvnoremap("J", "3gj", "Three visual lines down")
nvnoremap("K", "3gk", "Three visual lines up")
nvnoremap("L", "3w", "Three words right")

-- More intuitive undo and redo
nnoremap("u", "u", "Undo")
nnoremap("U", "<C-r>", "Redo")

-- Quickly move between and manipulate panes
nnoremap("<C-h>", "<C-w>h", "Go to the left window")
nnoremap("<C-j>", "<C-w>j", "Go to the down window")
nnoremap("<C-k>", "<C-w>k", "Go to the up window")
nnoremap("<C-l>", "<C-w>l", "Go to the right window")
nnoremap("<C-x>", "<C-w>x", "Swap with the next window")

-- Split panes
nnoremap("<Leader>s", ":split<CR>", "Split this window horizontally")
nnoremap("<Leader>S", ":vsplit<CR>", "Split this window horizontally")

-- Quick buffer management
nnoremap("<Leader>q", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local name = vim.api.nvim_buf_get_name(bufnr)

    if not modified then
        vim.cmd("q")
        return
    end

    vim.ui.input({
        prompt = "Save unwritten changes to " .. name .. "?\n[Y]es, (N)o, (C)ancel: ",
    }, function(input)
        if input == nil or input == "" or input == "c" or input == "C" then
            return
        end

        if input == "n" or input == "N" then
            vim.cmd("q!")
            return
        end

        if name == "" then
            print("Error: No file name")
            return
        end

        vim.cmd("wq")
    end)
end, "Quit")
nnoremap("<Leader>Q", ":qa<CR>", "Quit all")
nnoremap("<Leader>w", ":w<CR>", "Write")
nnoremap("<Leader>W", ":wa<CR>", "Write all")

-- Quick tab management
nnoremap("<C-f>", ":tabnext<CR>", "Next tab")
nnoremap("<C-s>", ":tabprevious<CR>", "Previous tab")
nnoremap("<C-b>", ":tabnew<CR>:NvimTreeOpen<CR>", "Open new tab")

-- Integrated terminal
local disable_numbers_and_signcolumn = function()
    vim.cmd.setlocal("nonumber norelativenumber signcolumn=no")
end
local enter_terminal_mode = function()
    vim.api.nvim_input("i")
end
local exit_terminal_mode = function()
    vim.api.nvim_input("<C-\\><C-n>")
end
local create_terminal = function(split_command, back_to_buffer_command)
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local name = vim.api.nvim_buf_get_name(bufnr)
    vim.cmd(split_command)
    vim.cmd.terminal()
    if name == "" and not modified then
        vim.cmd(back_to_buffer_command)
        vim.cmd.quit()
    end
    disable_numbers_and_signcolumn()
    enter_terminal_mode()
end
local create_horizontal_terminal = function()
    create_terminal("split", "wincmd k")
end
local create_vertical_terminal = function()
    create_terminal("vsplit", "wincmd h")
end
local create_inplace_terminal = function()
    vim.cmd("terminal")
    disable_numbers_and_signcolumn()
end
local refresh_terminal = function()
    exit_terminal_mode()
    create_inplace_terminal()
    enter_terminal_mode()
end
local left_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>h")
end
local down_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>j")
end
local up_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>k")
end
local right_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>l")
end
local next_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabnext()
end
local previous_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabprevious()
end
local open_new_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabnew()
    vim.cmd.NvimTreeOpen()
end
nnoremap("<Leader>t", create_horizontal_terminal, "Open horizontal terminal")
nnoremap("<Leader>T", create_vertical_terminal, "Open vertical terminal")
tnoremap("<C-e>", exit_terminal_mode, "Exit terminal mode")
tnoremap("<C-h>", left_from_terminal, "Go to the left window")
tnoremap("<C-j>", down_from_terminal, "Go to the down window")
tnoremap("<C-k>", up_from_terminal, "Go to the up window")
tnoremap("<C-l>", right_from_terminal, "Go to the right window")
tnoremap("<C-d>", "<C-D>", "Close terminal")
tnoremap("<C-r>", refresh_terminal, "Refresh terminal")
tnoremap("<C-f>", next_tab_from_terminal, "Next tab")
tnoremap("<C-s>", previous_tab_from_terminal, "Previous tab")
tnoremap("<C-b>", open_new_tab_from_terminal, "Open new tab")

-- NvimTree key mappings
local nvim_tree_api = require("nvim-tree.api")
nnoremap("<C-p>", nvim_tree_api.tree.toggle, "Toggle file tree")

-- WhichKey mappings
nnoremap("<Leader>?", ":WhichKey<CR>", "Show custom keymaps")

-- Zen mode
nnoremap("<Leader>f", ":ZenMode<CR>", "Toggle zen mode")

-- Yanky
nxnoremap("y", "<Plug>(YankyYank)")
nxnoremap("p", "<Plug>(YankyPutAfter)")
nxnoremap("P", "<Plug>(YankyPutBefore)")
nxnoremap("gp", "<Plug>(YankyGPutAfter)")
nxnoremap("gP", "<Plug>(YankyGPutBefore)")
nnoremap("t", "<Plug>(YankyCycleForward)")
nnoremap("T", "<Plug>(YankyCycleBackward)")
nnoremap("]p", "<Plug>(YankyPutIndentAfterLinewise)")
nnoremap("[p", "<Plug>(YankyPutIndentBeforeLinewise)")
nnoremap("]P", "<Plug>(YankyPutIndentAfterLinewise)")
nnoremap("[P", "<Plug>(YankyPutIndentBeforeLinewise)")
nnoremap(">p", "<Plug>(YankyPutIndentAfterShiftRight)")
nnoremap("<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
nnoremap(">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
nnoremap("<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
nnoremap("=p", "<Plug>(YankyPutAfterFilter)")
nnoremap("=P", "<Plug>(YankyPutBeforeFilter)")

-- Documentation generator (Doge)
vim.g.doge_enable_mappings = 0;
nnoremap("<Leader>d", "<Plug>(doge-generate)", "Doc gen")
noremap({ "n", "i", "x" }, "<Tab>", "<Plug>(doge-comment-jump-forward)", "Doc next field")
noremap({ "n", "i", "x" }, "<S-Tab>", "<Plug>(doge-comment-jump-backward)", "Doc previous field")

-- Remove all UI elements except for the text itself.
nnoremap("<Leader>F",
    ":set noruler noshowmode noshowcmd laststatus=0 signcolumn=no nonumber norelativenumber nocursorline showtabline=0<CR>",
    "Hide all UI elements")

-- Switch between light and dark mode.
nnoremap("<Leader>L", ":set background=light<CR>", "Enable light mode")
nnoremap("<Leader>D", ":set background=dark<CR>", "Enable dark mode")
