-- Visual Studio Dark Theme for Neovim
-- Based on Visual Studio 2022 Dark Theme

local colors = {
    bg = "#1e1e1e",
    fg = "#dcdcdc",
    keyword = "#569cd6",
    type = "#4ec9b0",
    string = "#d69d85",
    method = "#dcdcaa",
    variable = "#9cdcfe",
    property = "#9cdcfe",
    comment = "#6a9955",
    xmldoc_tag = "#608b4e",
    number = "#b5cea8",
    operator = "#d4d4d4",
    line_nr = "#858585",
    selection = "#264f78",
    error = "#f44747",
    warning = "#ff8c00",
    info = "#569cd6",
    hint = "#4ec9b0",
    search = "#e8ab53",  -- Orange für Such-Highlight

    -- UI Farben
    cursor_line = "#2d2d2d",
    popup_bg = "#252526",
    popup_border = "#3c3c3c",
    menu_bg = "#252526",
    menu_sel = "#094771",
    fold = "#5a5a5a",

    -- Git/Diff
    git_add = "#587c0c",
    git_change = "#0c7d9d",
    git_delete = "#94151b",
}

-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "vsdark"
vim.o.termguicolors = true
vim.o.background = "dark"

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ============================================================================
-- Editor UI
-- ============================================================================
hi("Normal", { fg = colors.fg, bg = colors.bg })
hi("NormalFloat", { fg = colors.fg, bg = colors.popup_bg })
hi("FloatBorder", { fg = colors.popup_border, bg = colors.popup_bg })
hi("Cursor", { fg = colors.bg, bg = colors.fg })
hi("CursorLine", { bg = colors.cursor_line })
hi("CursorColumn", { bg = colors.cursor_line })
hi("LineNr", { fg = colors.line_nr })
hi("CursorLineNr", { fg = colors.fg, bold = true })
hi("SignColumn", { bg = colors.bg })
hi("VertSplit", { fg = colors.popup_border })
hi("WinSeparator", { fg = colors.popup_border })
hi("StatusLine", { fg = colors.fg, bg = colors.popup_bg })
hi("StatusLineNC", { fg = colors.line_nr, bg = colors.popup_bg })
hi("TabLine", { fg = colors.line_nr, bg = colors.popup_bg })
hi("TabLineFill", { bg = colors.popup_bg })
hi("TabLineSel", { fg = colors.fg, bg = colors.bg, bold = true })
hi("Folded", { fg = colors.fold, bg = colors.cursor_line })
hi("FoldColumn", { fg = colors.fold, bg = colors.bg })
hi("ColorColumn", { bg = colors.cursor_line })
hi("Conceal", { fg = colors.line_nr })
hi("NonText", { fg = colors.line_nr })
hi("SpecialKey", { fg = colors.line_nr })
hi("EndOfBuffer", { fg = colors.bg })

-- ============================================================================
-- Search & Selection
-- ============================================================================
hi("Visual", { bg = colors.selection })
hi("VisualNOS", { bg = colors.selection })
hi("Search", { fg = colors.bg, bg = colors.search, bold = true })
hi("IncSearch", { fg = colors.bg, bg = colors.search, bold = true })
hi("CurSearch", { fg = colors.bg, bg = colors.search, bold = true })
hi("Substitute", { fg = colors.bg, bg = colors.search })

-- ============================================================================
-- Popup Menu
-- ============================================================================
hi("Pmenu", { fg = colors.fg, bg = colors.menu_bg })
hi("PmenuSel", { fg = colors.fg, bg = colors.menu_sel })
hi("PmenuSbar", { bg = colors.popup_bg })
hi("PmenuThumb", { bg = colors.line_nr })

-- ============================================================================
-- Messages
-- ============================================================================
hi("ErrorMsg", { fg = colors.error })
hi("WarningMsg", { fg = colors.warning })
hi("ModeMsg", { fg = colors.fg, bold = true })
hi("MoreMsg", { fg = colors.type })
hi("Question", { fg = colors.type })
hi("Title", { fg = colors.keyword, bold = true })
hi("Directory", { fg = "#d4a959" })
hi("SnacksPickerDirectory", { fg = colors.fg })

-- ============================================================================
-- Diff
-- ============================================================================
hi("DiffAdd", { bg = "#2d4a2d" })
hi("DiffChange", { bg = "#2d3a4a" })
hi("DiffDelete", { fg = colors.error, bg = "#4a2d2d" })
hi("DiffText", { bg = "#3a4a5a" })

-- ============================================================================
-- Spell
-- ============================================================================
hi("SpellBad", { undercurl = true, sp = colors.error })
hi("SpellCap", { undercurl = true, sp = colors.warning })
hi("SpellLocal", { undercurl = true, sp = colors.info })
hi("SpellRare", { undercurl = true, sp = colors.hint })

-- ============================================================================
-- Standard Syntax Highlighting
-- ============================================================================
hi("Comment", { fg = colors.comment, italic = true })
hi("Constant", { fg = colors.variable })
hi("String", { fg = colors.string })
hi("Character", { fg = colors.string })
hi("Number", { fg = colors.number })
hi("Float", { fg = colors.number })
hi("Boolean", { fg = colors.keyword })
hi("Identifier", { fg = colors.variable })
hi("Function", { fg = colors.method })
hi("Statement", { fg = colors.keyword })
hi("Conditional", { fg = colors.keyword })
hi("Repeat", { fg = colors.keyword })
hi("Label", { fg = colors.keyword })
hi("Operator", { fg = colors.operator })
hi("Keyword", { fg = colors.keyword })
hi("Exception", { fg = colors.keyword })
hi("PreProc", { fg = colors.keyword })
hi("Include", { fg = colors.keyword })
hi("Define", { fg = colors.keyword })
hi("Macro", { fg = colors.keyword })
hi("PreCondit", { fg = colors.keyword })
hi("Type", { fg = colors.type })
hi("StorageClass", { fg = colors.keyword })
hi("Structure", { fg = colors.type })
hi("Typedef", { fg = colors.type })
hi("Special", { fg = colors.variable })
hi("SpecialChar", { fg = colors.string })
hi("Tag", { fg = colors.keyword })
hi("Delimiter", { fg = colors.fg })
hi("SpecialComment", { fg = colors.comment })
hi("Debug", { fg = colors.warning })
hi("Underlined", { underline = true })
hi("Error", { fg = colors.error })
hi("Todo", { fg = colors.bg, bg = colors.warning, bold = true })

-- ============================================================================
-- Treesitter Highlights
-- ============================================================================
-- Comments
hi("@comment", { fg = colors.comment, italic = true })
hi("@comment.documentation", { fg = colors.comment, italic = true })

-- Constants
hi("@constant", { fg = colors.variable })
hi("@constant.builtin", { fg = colors.keyword })
hi("@constant.macro", { fg = colors.keyword })

-- Strings
hi("@string", { fg = colors.string })
hi("@string.escape", { fg = colors.keyword })
hi("@string.special", { fg = colors.string })
hi("@string.documentation", { fg = colors.comment })

-- Characters
hi("@character", { fg = colors.string })
hi("@character.special", { fg = colors.keyword })

-- Numbers
hi("@number", { fg = colors.number })
hi("@number.float", { fg = colors.number })

-- Booleans
hi("@boolean", { fg = colors.keyword })

-- Functions
hi("@function", { fg = colors.method })
hi("@function.builtin", { fg = colors.method })
hi("@function.call", { fg = colors.method })
hi("@function.macro", { fg = colors.method })
hi("@method", { fg = colors.method })
hi("@method.call", { fg = colors.method })

-- Keywords
hi("@keyword", { fg = colors.keyword })
hi("@keyword.coroutine", { fg = colors.keyword })
hi("@keyword.function", { fg = colors.keyword })
hi("@keyword.operator", { fg = colors.keyword })
hi("@keyword.import", { fg = colors.keyword })
hi("@keyword.storage", { fg = colors.keyword })
hi("@keyword.repeat", { fg = colors.keyword })
hi("@keyword.return", { fg = colors.keyword })
hi("@keyword.debug", { fg = colors.keyword })
hi("@keyword.exception", { fg = colors.keyword })
hi("@keyword.conditional", { fg = colors.keyword })
hi("@keyword.conditional.ternary", { fg = colors.keyword })
hi("@keyword.directive", { fg = colors.keyword })
hi("@keyword.directive.define", { fg = colors.keyword })

-- Operators
hi("@operator", { fg = colors.operator })

-- Punctuation
hi("@punctuation.delimiter", { fg = colors.fg })
hi("@punctuation.bracket", { fg = colors.fg })
hi("@punctuation.special", { fg = colors.keyword })

-- Variables
hi("@variable", { fg = colors.variable })
hi("@variable.builtin", { fg = colors.keyword })
hi("@variable.parameter", { fg = colors.variable })
hi("@variable.member", { fg = colors.property })

-- Types
hi("@type", { fg = colors.type })
hi("@type.builtin", { fg = colors.type })
hi("@type.definition", { fg = colors.type })
hi("@type.qualifier", { fg = colors.keyword })

-- Attributes
hi("@attribute", { fg = colors.type })
hi("@property", { fg = colors.property })
hi("@field", { fg = colors.property })

-- Labels
hi("@label", { fg = colors.keyword })

-- Namespaces (weiß wie normaler Text)
hi("@namespace", { fg = colors.fg })
hi("@namespace.c_sharp", { fg = colors.fg })
hi("@module", { fg = colors.fg })
hi("@module.c_sharp", { fg = colors.fg })
hi("@lsp.type.namespace", { fg = colors.fg })
hi("@type.qualifier", { fg = colors.fg })

-- Tags (XML/HTML)
hi("@tag", { fg = colors.keyword })
hi("@tag.attribute", { fg = colors.variable })
hi("@tag.delimiter", { fg = colors.fg })

-- Constructor
hi("@constructor", { fg = colors.type })

-- ============================================================================
-- LSP Semantic Tokens
-- ============================================================================
hi("@lsp.type.class", { fg = colors.type })
hi("@lsp.type.decorator", { fg = colors.type })
hi("@lsp.type.enum", { fg = colors.type })
hi("@lsp.type.enumMember", { fg = colors.variable })
hi("@lsp.type.function", { fg = colors.method })
hi("@lsp.type.interface", { fg = colors.type })
hi("@lsp.type.macro", { fg = colors.keyword })
hi("@lsp.type.method", { fg = colors.method })
hi("@lsp.type.namespace", { fg = colors.fg })
hi("@lsp.type.parameter", { fg = colors.variable })
hi("@lsp.type.property", { fg = colors.property })
hi("@lsp.type.struct", { fg = colors.type })
hi("@lsp.type.type", { fg = colors.type })
hi("@lsp.type.typeParameter", { fg = colors.type })
hi("@lsp.type.variable", { fg = colors.variable })

-- ============================================================================
-- Diagnostics
-- ============================================================================
hi("DiagnosticError", { fg = colors.error })
hi("DiagnosticWarn", { fg = colors.warning })
hi("DiagnosticInfo", { fg = colors.info })
hi("DiagnosticHint", { fg = colors.hint })
hi("DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })
hi("DiagnosticVirtualTextError", { fg = colors.error })
hi("DiagnosticVirtualTextWarn", { fg = colors.warning })
hi("DiagnosticVirtualTextInfo", { fg = colors.info })
hi("DiagnosticVirtualTextHint", { fg = colors.hint })
hi("DiagnosticSignError", { fg = colors.error })
hi("DiagnosticSignWarn", { fg = colors.warning })
hi("DiagnosticSignInfo", { fg = colors.info })
hi("DiagnosticSignHint", { fg = colors.hint })

-- ============================================================================
-- Git Signs
-- ============================================================================
hi("GitSignsAdd", { fg = colors.git_add })
hi("GitSignsChange", { fg = colors.git_change })
hi("GitSignsDelete", { fg = colors.git_delete })

-- ============================================================================
-- Snacks Explorer Git Status
-- ============================================================================
hi("SnacksPickerGitStatusModified", { fg = "#e2c08d" })
hi("SnacksPickerGitStatusStaged", { fg = colors.hint })
hi("SnacksPickerGitStatusAdded", { fg = "#89d185" })
hi("SnacksPickerGitStatusDeleted", { fg = colors.error })
hi("SnacksPickerGitStatusUntracked", { fg = "#89d185" })
hi("SnacksPickerGitStatusRenamed", { fg = "#e2c08d" })
hi("SnacksPickerGitStatusUnmerged", { fg = colors.error })

-- ============================================================================
-- Telescope
-- ============================================================================
hi("TelescopeBorder", { fg = colors.popup_border })
hi("TelescopePromptBorder", { fg = colors.popup_border })
hi("TelescopeResultsBorder", { fg = colors.popup_border })
hi("TelescopePreviewBorder", { fg = colors.popup_border })
hi("TelescopeSelection", { bg = colors.selection })
hi("TelescopeMatching", { fg = colors.search, bold = true })

-- ============================================================================
-- Which-Key
-- ============================================================================
hi("WhichKey", { fg = colors.method })
hi("WhichKeyGroup", { fg = colors.keyword })
hi("WhichKeySeparator", { fg = colors.comment })
hi("WhichKeyDesc", { fg = colors.fg })

-- ============================================================================
-- Indent Blankline
-- ============================================================================
hi("IndentBlanklineChar", { fg = colors.popup_border })
hi("IndentBlanklineContextChar", { fg = colors.line_nr })

-- ============================================================================
-- NvimTree / Neo-tree
-- ============================================================================
hi("NvimTreeNormal", { fg = colors.fg, bg = colors.bg })
hi("NvimTreeFolderName", { fg = colors.fg })
hi("NvimTreeFolderIcon", { fg = colors.keyword })
hi("NvimTreeOpenedFolderName", { fg = colors.fg, bold = true })
hi("NvimTreeRootFolder", { fg = colors.keyword, bold = true })
hi("NvimTreeSpecialFile", { fg = colors.method })
hi("NvimTreeGitDirty", { fg = colors.warning })
hi("NvimTreeGitNew", { fg = colors.git_add })
hi("NvimTreeGitDeleted", { fg = colors.git_delete })

-- ============================================================================
-- Lazy.nvim
-- ============================================================================
hi("LazyH1", { fg = colors.bg, bg = colors.keyword, bold = true })
hi("LazyButton", { fg = colors.fg, bg = colors.popup_bg })
hi("LazyButtonActive", { fg = colors.bg, bg = colors.keyword })
hi("LazySpecial", { fg = colors.type })

-- ============================================================================
-- Match Paren
-- ============================================================================
hi("MatchParen", { fg = colors.warning, bold = true })

-- ============================================================================
-- OmniSharp Semantic Highlighting (C#)
-- ============================================================================
hi("csUserType", { fg = colors.type })           -- Classes, Enums, Structs
hi("csUserInterface", { fg = colors.type })      -- Interfaces
hi("csUserMethod", { fg = colors.method })       -- Methods
hi("csUserIdentifier", { fg = colors.variable }) -- Variables, Parameters
hi("csUserNamespace", { fg = colors.fg })        -- Namespaces (weiß)
