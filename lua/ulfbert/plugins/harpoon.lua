return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>t", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>to", function() harpoon:list():remove() end)

        vim.keymap.set("n", "<leader>tt", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        
        vim.keymap.set("n", "<leader>tn", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>te", function() harpoon:list():next() end)
    end
}
