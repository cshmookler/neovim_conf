return function()
    vim.api.nvim_create_user_command("DogeInstall", "call doge#install()", {})
end
