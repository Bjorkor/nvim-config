return {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
        require("mason").setup()
        require("mason_lspconfig").setup()
        require("lspconfig").pyright.setup {}
    end
}
