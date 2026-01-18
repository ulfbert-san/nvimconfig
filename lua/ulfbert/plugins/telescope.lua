local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ss', builtin.find_files, {})

vim.keymap.set('n', '<leader>sn', function()
    builtin.grep_string({ search = vim.fn.input("Suche nach > ") })
end)

vim.keymap.set('n', '<leader>sw', builtin.grep_string, {})

vim.keymap.set('n', '<leader>sm', function()
    builtin.treesitter({ default_text = "method " })
end, { desc = "Treesitter Methoden" })

vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = "Treesitter alle Symbole" })

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
}
