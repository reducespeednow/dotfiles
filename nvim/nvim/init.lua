require("saraabdullahi.lazy")
require("saraabdullahi.remap")
require("saraabdullahi.set")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(function()
            vim.cmd("silent !kitty @ set-spacing padding=0")
        end, 100)
    end,
})

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.cmd("silent !kitty @ set-spacing padding=20")
    end,
})
