if vim.env.KITTY_WINDOW_ID then
    local group = vim.api.nvim_create_augroup("KittyPadding", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
            vim.system({ "kitty", "@", "set-spacing", "padding=0" })
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        callback = function()
            vim.system({ "kitty", "@", "set-spacing", "padding=20" })
        end,
    })
end
