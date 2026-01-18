-- Visual Studio Dark Theme Plugin Configuration
-- Das Colorscheme liegt in nvim/colors/vsdark.lua
return {
    "vsdark",
    name = "vsdark",
    virtual = true,  -- Kein echtes Plugin, nur Config
    priority = 1000,
    lazy = false,
    config = function()
        vim.cmd("colorscheme vsdark")
    end
}
