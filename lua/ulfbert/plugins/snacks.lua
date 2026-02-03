return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        animate = { enabled = false },  -- Deaktiviert, verursacht Cursor-Flackern
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
        picker = {
            win = {
                list = {
                    keys = {
                        ["s"] = "edit_vsplit",
                    },
                },
            },
        },
        git = {},
        gitbrowse = {},
        image = { enabled = false },
        indent = {},
        input = {},
        layout = {},
        lazygit = {
            win = {
                position = "float",
                width = 0.9,
                height = 0.9,
                border = "rounded",
            },
        },
        notifier = { enabled = false },  -- Deaktiviert, verursacht Cursor-Flackern mit LSP
        quickfile = {},
        scope = {},
        scratch = {},
        scroll = { enabled = false },
        terminal = {
            enabled = true,
            win = {
                style = "terminal",
                position = "bottom",
                height = 0.3,
                border = "top",
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
        { "<A-t>", function() require("snacks").terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },

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
