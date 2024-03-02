return {
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            local lsp_zero = require("lsp-zero")

            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                --keybinds go here
                --:help lsp-zero-keybindings
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {"pyright", "lua_ls", "bashls"},
                handlers = {
                    lsp_zero.default_setup,
                },
            })
            lsp_zero.omnifunc.setup({
                autocomplete = true,
                use_fallback = true,
                update_on_delete = true,
                trigger = '<C-Space>',
            })
            lsp_zero.setup_servers({'pyright', 'lua_ls', 'bashls'})
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

        end
    },
}
