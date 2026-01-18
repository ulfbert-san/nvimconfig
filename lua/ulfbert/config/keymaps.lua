vim.g.mapleader = " "

-- Exit
vim.keymap.set("n", "<leader>a", vim.cmd.Ex)

-- Moving Lines
vim.keymap.set("n", "<A-e>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-i>", ":m .-2<CR>==")

-- Dublicate content
vim.keymap.set("n", "<A-d>", ":t.<CR>")

-- Window Navigation
vim.keymap.set("n", "<C-w>n", "<C-w>h")
vim.keymap.set("n", "<C-w>e", "<C-w>j")
vim.keymap.set("n", "<C-w>i", "<C-w>k")
vim.keymap.set("n", "<C-w>o", "<C-w>l")

-- Moving Cursor
vim.keymap.set("n", "n", "h")
vim.keymap.set("n", "e", "j")
vim.keymap.set("n", "i", "k")
vim.keymap.set("n", "o", "l")

-- Jumplist Navigation (da <C-i> durch Colemak belegt ist)
vim.keymap.set("n", "<C-h>", "<C-i>", { noremap = true })

vim.keymap.set("n", "N", "H")
vim.keymap.set("n", "O", "L")

vim.keymap.set("n", "k", "e")
vim.keymap.set("n", "K", "E")

-- Switch (Insert Mode)
vim.keymap.set("n", "h", "i")
vim.keymap.set("n", "H", "I")
vim.keymap.set("n", "l", "o")
vim.keymap.set("n", "L", "O")

-- Searching
vim.keymap.set("n", "j", "n")
vim.keymap.set("n", "J", "N")

-- Visual Mode Navigation (Colemak)
vim.keymap.set("v", "n", "h")
vim.keymap.set("v", "e", "j")
vim.keymap.set("v", "i", "k")
vim.keymap.set("v", "o", "l")

-- Visual Mode: Ersatz für überschriebene Funktionen
vim.keymap.set("v", "h", "i")  -- Text objects: vh" statt vi"
vim.keymap.set("v", "l", "o")  -- Selection-Ende wechseln

function test()
    vim.fn.expand("%:h")

    -- Prompt the user to input a string
    local input = vim.fn.input("Enter a filename: ")

    -- Check if input is not empty
    if input and input ~= "" then
        -- Replace `YourCommand` with the command you want to run
        -- print("!dotnet new class -n " .. input .. " -o " .. vim.fn.expand("%:h"))
        vim.cmd("!dotnet new class -n " .. input .. " -o " .. vim.fn.expand("%:h"))
    else
        print("No input provided!")
    end
end

-- Map <leader>% to create a new C# class
vim.keymap.set("n", "<leader>%", ":lua test()<CR>", { noremap = true, silent = true })

-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf, noremap = true, silent = true }

        -- Go to definition
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Go to declaration
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        -- Go to type definition
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

        -- Go to implementation
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

        -- Show references
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- Hover information
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Signature help
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-Space>", vim.lsp.buf.signature_help, opts)

        -- Rename symbol
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- Code actions
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Format code
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

        -- Show diagnostics
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        -- Navigate diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})