return {
    -- OmniSharp-vim for C# development
    {
        "OmniSharp/omnisharp-vim",
        ft = { "cs", "csx", "vb" },
        init = function()
            -- Wenn eine .sln im cwd liegt, OmniSharp sofort laden
            if vim.fn.glob("*.sln") ~= "" then
                vim.api.nvim_create_autocmd("UIEnter", {
                    once = true,
                    callback = function()
                        require("lazy").load({ plugins = { "omnisharp-vim" } })
                    end,
                })
            end
        end,
        config = function()
            -- OmniSharp configuration based on example config
            vim.g.OmniSharp_popup_position = 'peek'
            
            -- Popup options for Neovim (optimized for signature help)
            vim.g.OmniSharp_popup_options = {
                winblend = 0,
                winhl = 'Normal:Normal,FloatBorder:ModeMsg',
                border = 'rounded'
            }
            
            -- Popup mappings for signature help
            vim.g.OmniSharp_popup_mappings = {
                sigNext = '<C-n>',
                sigPrev = '<C-p>',
                pageDown = { '<C-f>', '<PageDown>' },
                pageUp = { '<C-b>', '<PageUp>' }
            }
            
            -- Enable snippet completion
            vim.g.OmniSharp_want_snippet = 0
            
            -- Highlight groups
            vim.g.OmniSharp_highlight_groups = {
                ExcludedCode = 'NonText',
                csUserNamespace = { 'namespace name' },
                csUserType = { 'class name', 'enum name', 'struct name', 'delegate name' },
                csUserInterface = { 'interface name' },
                csUserMethod = { 'extension method name', 'method name' },
                csUserIdentifier = {
                    'constant name', 'enum member name', 'field name', 'identifier',
                    'local name', 'parameter name', 'property name', 'static symbol'
                },
            }
            
            -- Completion configuration
            vim.g.OmniSharp_popup_auto_select = 0  -- Deaktiviert für asyncomplete
            vim.g.OmniSharp_highlight_types = 2  -- Show types in completion

            -- Timeout-Einstellungen
            vim.g.OmniSharp_timeout = 5  -- 5 Sekunden Timeout
            vim.g.OmniSharp_server_stdio = 1  -- Bessere Performance
            
            -- Key mappings for C# files
            vim.api.nvim_create_augroup("omnisharp_commands", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = "omnisharp_commands",
                pattern = "cs",
                callback = function()
                    local opts = { buffer = true, silent = true }

                    -- Navigation mappings
                    vim.keymap.set("n", "gd", "<Plug>(omnisharp_go_to_definition)", opts)
                    vim.keymap.set("n", "<Leader>pfu", "<Plug>(omnisharp_find_usages)", opts)
                    vim.keymap.set("n", "<Leader>pfi", "<Plug>(omnisharp_find_implementations)", opts)
                    vim.keymap.set("n", "<Leader>ppd", "<Plug>(omnisharp_preview_definition)", opts)
                    vim.keymap.set("n", "<Leader>ppi", "<Plug>(omnisharp_preview_implementations)", opts)
                    vim.keymap.set("n", "<Leader>pt", "<Plug>(omnisharp_type_lookup)", opts)
                    vim.keymap.set("n", "<Leader>pd", "<Plug>(omnisharp_documentation)", opts)
                    vim.keymap.set("n", "<Leader>pfs", "<Plug>(omnisharp_find_symbol)", opts)
                    vim.keymap.set("n", "<Leader>pfx", "<Plug>(omnisharp_fix_usings)", opts)
                    vim.keymap.set("n", "<C-\\>", "<Plug>(omnisharp_signature_help)", opts)
                    vim.keymap.set("i", "<C-\\>", "<Plug>(omnisharp_signature_help)", opts)

                    -- Additional signature help keymaps
                    vim.keymap.set("i", "<C-Space>", ":OmniSharpSignatureHelp<CR>", opts)
                    vim.keymap.set("n", "<Leader>ppd", ":OmniSharpPreviewDefinition<CR>", opts)

                    -- Close popups
                    vim.keymap.set("i", "<C-e>", function()
                        vim.cmd("pclose")
                    end, opts)
                    vim.keymap.set("n", "<C-e>", function()
                        vim.cmd("pclose")
                    end, opts)

                    -- Close completion popup on Escape
                    vim.keymap.set("i", "<Esc>", function()
                        vim.cmd("pclose")
                        vim.cmd("stopinsert")
                    end, opts)

                    -- Close popup on Tab (if no completion selected)
                    vim.keymap.set("i", "<Tab>", function()
                        if vim.fn.pumvisible() == 0 then
                            vim.cmd("pclose")
                        end
                    end, opts)

                    -- Navigate up and down by method/property/field
                    vim.keymap.set("n", "[[", "<Plug>(omnisharp_navigate_up)", opts)
                    vim.keymap.set("n", "]]", "<Plug>(omnisharp_navigate_down)", opts)

                    -- Code actions and formatting
                    vim.keymap.set("n", "<Leader>pgcc", "<Plug>(omnisharp_global_code_check)", opts)
                    vim.keymap.set("n", "<Leader>pca", "<Plug>(omnisharp_code_actions)", opts)
                    vim.keymap.set("x", "<Leader>pca", "<Plug>(omnisharp_code_actions)", opts)
                    vim.keymap.set("n", "<Leader>p.", "<Plug>(omnisharp_code_action_repeat)", opts)
                    vim.keymap.set("x", "<Leader>p.", "<Plug>(omnisharp_code_action_repeat)", opts)
                    vim.keymap.set("n", "<Leader>pm", "<Plug>(omnisharp_code_format)", opts)
                    vim.keymap.set("n", "<Leader>pnm", function()
                        local bufnr = vim.api.nvim_get_current_buf()
                        local augroup = vim.api.nvim_create_augroup("omnisharp_rename_fix", { clear = true })
                        vim.api.nvim_create_autocmd("TextChanged", {
                            group = augroup,
                            buffer = bufnr,
                            once = true,
                            callback = function()
                                vim.treesitter.stop(bufnr)
                                vim.treesitter.start(bufnr)
                            end
                        })
                        vim.cmd("OmniSharpRename")
                    end, opts)

                    -- Server control
                    vim.keymap.set("n", "<Leader>pre", "<Plug>(omnisharp_restart_server)", opts)
                    vim.keymap.set("n", "<Leader>pst", "<Plug>(omnisharp_start_server)", opts)
                    vim.keymap.set("n", "<Leader>psp", "<Plug>(omnisharp_stop_server)", opts)

                    -- Signature help on opening parenthesis (only after method names)
                    vim.keymap.set("i", "(", function()
                        local line = vim.api.nvim_get_current_line()
                        local col = vim.api.nvim_win_get_cursor(0)[2]  -- 0-based
                        local before_cursor = line:sub(1, col)  -- Text vor dem Cursor

                        local keys = ""

                        -- Wenn Popup-Menü sichtbar: per Rückgabestring schließen (statt feedkeys)
                        if vim.fn.pumvisible() == 1 then
                            keys = keys .. vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
                        end

                        -- Nur nach Methoden-/Funktionsnamen Signature Help auslösen
                        if before_cursor:match("[%w_]+%s*$") then
                            vim.defer_fn(function()
                                vim.cmd("OmniSharpSignatureHelp")
                            end, 100)
                        end

                        -- Am Ende wirklich "(" einfügen
                        keys = keys .. "("
                        return keys
                    end, { expr = true, noremap = true, silent = true })

                    -- Close signature help on closing parenthesis
                    vim.keymap.set("i", ")", function()
                        -- Zeichen durch Rückgabewert einfügen (saubere Undo-Granularität)
                        vim.schedule(function()
                            pcall(vim.fn["OmniSharp#popup#Close"])
                        end)
                        return ")"
                    end, { expr = true, noremap = true })
                end
            })
        end
    }
}
