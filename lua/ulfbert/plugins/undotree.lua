vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.g.undotree_SplitWidth = 40 
vim.g.undotree_DiffAutoOpen = 0
vim.g.undotree_SetFocusWhenToggle = 1

vim.api.nvim_create_autocmd("FileType", {
    pattern = "undotree",
    callback = function()
        vim.keymap.set("n", "e", "J", { buffer = true, remap = true, desc = "Previous undo state" })
        vim.keymap.set("n", "i", "K", { buffer = true, remap = true, desc = "Next undo state" })
    end,
})

return {
    "mbbill/undotree"
}
