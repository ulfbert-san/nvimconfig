-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Line wrapping
vim.opt.wrap = false
vim.opt.textwidth = 80

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("USERPROFILE") .. "/AppData/Local/nvim-data/undo"
vim.opt.undofile = true
vim.opt.encoding = "utf-8"
vim.opt.fixendofline = false

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 2
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.title = true

-- Nerd Font
vim.g.have_nerd_font = true

-- Editing behavior
vim.opt.backspace = "indent,eol,start"
vim.opt.hidden = true
vim.opt.startofline = false
vim.opt.mouse = "a"

-- Window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Other
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

-- MatchParen: Verhindert Cursor-Flackern beim Highlighting
vim.g.matchparen_disable_cursor_hl = 1
