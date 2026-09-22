return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded" },
        })

        vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities(), })
        vim.lsp.enable({ "lua_ls" })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
                end

                map("n", "gd", vim.lsp.buf.definition, "Goto definition")
                map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
                map("n", "<leader>vd", vim.diagnostic.open_float, "Line diagnostics")
                map("n", "<leader>vca", vim.lsp.buf.code_action, "Code action")
                map("n", "<leader>vrr", vim.lsp.buf.references, "References")
                map("n", "<leader>vrn", vim.lsp.buf.rename, "Rename symbol")
                map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")
            end,
        })

        local cmp = require("cmp")
        cmp.setup({
            sources = {
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "buffer" },
            },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            snippet = {
                expand = function(args) vim.snippet.expand(args.body) end,
            },
        })
    end,
}
