return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        { "L3MON4D3/LuaSnip",     build = "make install_jsregexp" },
        "saadparwaiz1/cmp_luasnip",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded" }
        })

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )
        vim.lsp.config("*", { capabilities = capabilities })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
                end

                map('n', 'gd', vim.lsp.buf.definition, "Goto definition")
                map('n', '<leader>vws', vim.lsp.buf.workspace_symbol, "Workspace symbols")
                map('n', '<leader>vd', vim.diagnostic.open_float, "Line diagnostics")
                map('n', '<leader>vca', vim.lsp.buf.code_action, "Code action")
                map('n', '<leader>vrr', vim.lsp.buf.references, "References")
                map('n', '<leader>vrn', vim.lsp.buf.rename, "Rename symbol")
                map('i', '<C-h>', vim.lsp.buf.signature_help, "Signature help")
            end,
        })

        require('mason-lspconfig').setup({
            ensure_installed = { "lua_ls" },
        })

        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
        })
    end
}
