return {
    {
        "nvim-flutter/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
        config = function()
            require("flutter-tools").setup({
                widget_guides = { enabled = true },
                closing_tags = { enabled = true },
                lsp = {
                    color = { enabled = true },
                },
                debugger = {
                    enabled = true,
                    run_via_dap = true,
                },
            })

            -- Keybindings
            vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run" })
            vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter Quit" })
            vim.keymap.set("n", "<leader>fl", "<cmd>FlutterReload<cr>", { desc = "Flutter Hot Reload" })
            vim.keymap.set("n", "<leader>fR", "<cmd>FlutterRestart<cr>", { desc = "Flutter Hot Restart" })
            vim.keymap.set("n", "<leader>fd", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices" })
            vim.keymap.set("n", "<leader>fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })
            vim.keymap.set("n", "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter Outline" })
        end,
    },
    {
        "mfussenegger/nvim-dap",
    },
}
