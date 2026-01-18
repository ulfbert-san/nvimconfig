return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        animate = {},
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" }
            }
        },
        dim = { enabled = false },
        explorer = {},
        git = {},
        gitbrowse = {},
        image = { enabled = false },
        indent = {},
        input = {},
        layout = {},
        lazygit = {},
        notifier = {},
        quickfile = {},
        scope = {},
        scratch = {},
        scroll = { enabled = false },
        terminal = {
            enabled = true,
            win = {
                style = "terminal",
                position = "float",
                width = 0.8,
                height = 0.8,
                row = 0.1,
                col = 0.1,
                border = "rounded",
                wo = {
                    winblend = 0,
                    winhighlight = "Normal:Normal,NormalFloat:Normal",
                },
            },
            shell = vim.o.shell,
        },
        util = {},
        win = {},
        zen = {},
    },
    keys = {
        -- Git
        { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
        { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },

        -- Terminal
        { "<c-/>", function() require("snacks").terminal() end, desc = "Toggle Terminal" },
        { "<c-_>", function() require("snacks").terminal() end, desc = "which_key_ignore" },

        -- Scratch
        { "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>sc", function() 
            require("snacks").scratch({
                ft = "cs",
                name = "C# Scratch",
            })
        end, desc = "C# Scratch Buffer" },

        -- Notifier
        { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
        { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },

        -- Zen
        { "<leader>z", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
        { "<leader>Z", function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },

        -- Explorer
        { "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },
    },
}
