return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()
        local ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", }
        require('nvim-treesitter').install(ensure_installed)
        local ts_group = vim.api.nvim_create_augroup("vim-treesitter-start", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = ts_group,
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
