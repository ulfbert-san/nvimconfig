require("ulfbert.config.keymaps")
require("ulfbert.config.set")
require("ulfbert.config.lazy")

-- Filetype and syntax settings
vim.cmd("filetype indent plugin on")
if not vim.g.syntax_on then
    vim.cmd("syntax enable")
end

-- Completion settings (set after asyncomplete)
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Clipboard settings
vim.opt.clipboard = "unnamedplus"

-- Colorscheme configuration
vim.api.nvim_create_augroup("ColorschemePreferences", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = "ColorschemePreferences",
    pattern = "*",
    callback = function()

        -- ALE sign highlights
        vim.api.nvim_set_hl(0, "ALEErrorSign", { link = "WarningMsg" })
        vim.api.nvim_set_hl(0, "ALEWarningSign", { link = "ModeMsg" })
        vim.api.nvim_set_hl(0, "ALEInfoSign", { link = "Identifier" })

        -- ALE underline highlights (undercurl for wavy lines)
        vim.api.nvim_set_hl(0, "ALEError", { undercurl = true, sp = "#ff5555" })
        vim.api.nvim_set_hl(0, "ALEWarning", { undercurl = true, sp = "#ffb86c" })
        vim.api.nvim_set_hl(0, "ALEInfo", { undercurl = true, sp = "#8be9fd" })

    end,
})

vim.opt.background = "dark"
-- Colorscheme wird jetzt über plugins/vsdark.lua geladen

vim.g.undotree_DiffCommand = "FC"

-- Cursor Blinken deaktivieren (nach allen Plugins)
vim.api.nvim_create_autocmd({"VimEnter", "BufEnter", "WinEnter"}, {
    callback = function()
        vim.opt.guicursor = "n-v-c:block-blinkon0-blinkoff0-blinkwait0,i-ci-ve:ver25-blinkon0-blinkoff0-blinkwait0,r-cr:hor20-blinkon0-blinkoff0-blinkwait0,o:hor50-blinkon0-blinkoff0-blinkwait0"
    end,
})