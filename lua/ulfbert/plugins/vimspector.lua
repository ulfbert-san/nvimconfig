return {
    {
        "puremourning/vimspector",
        config = function()
            vim.keymap.set("n", "<leader>dr", "<Plug>VimspectorLaunch")
            vim.keymap.set("n", "<leader>dn", "<Plug>VimspectorStepOver")
            vim.keymap.set("n", "<leader>ds", "<Plug>VimspectorStepInto")
            vim.keymap.set("n", "<leader>df", "<Plug>VimspectorStepOut")
            vim.keymap.set("n", "<leader>dc", "<Plug>VimspectorContinue")
        end
    }
}
