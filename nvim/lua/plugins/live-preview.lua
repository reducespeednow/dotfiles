return {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require("live-preview").setup({
            port = 5500,
            browser = "default",
            sync_scroll = true,
        })
    end
}
