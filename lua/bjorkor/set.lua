vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = 'lemonade',
    copy = {
        ['+'] = 'lemonade copy',
        ['*'] = 'lemonade copy',
    },
    paste = {
        ['+'] = 'lemonade paste',
        ['*'] = 'lemonade paste',
    },
    cache_enabled = 1,
}
vim.api.nvim_set_var('python3_host_prog', '~/nvim-venv/bin/python')
