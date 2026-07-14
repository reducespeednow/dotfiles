return {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    keys = {
        { "<leader>mp", "<cmd>LivePreview start<CR>", desc = "Live preview start" },
        { "<leader>ms", "<cmd>LivePreview close<CR>", desc = "Live preview stop" },
    },
    opts = {
        port = 5500,
        browser = "default",
        sync_scroll = true
    }
}
