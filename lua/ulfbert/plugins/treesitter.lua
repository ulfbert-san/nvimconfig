local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    priority = 100,
    config = function()
        require("nvim-treesitter.install").compilers = { "zig", "clang", "gcc", "cl" }
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c_sharp", "lua", "vim", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
        })

        -- Treesitter-based folding für unterstützte Dateitypen
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cs", "lua", "javascript", "typescript", "python" },
            callback = function()
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo.foldenable = true
                vim.wo.foldlevel = 99
            end
        })

        -- Funktion: Finde die aktuelle Funktion/Methode via Treesitter (native API)
        local function get_current_function_range()
            local bufnr = vim.api.nvim_get_current_buf()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local row = cursor[1] - 1  -- 0-indexed
            local col = cursor[2]

            -- Hole den Treesitter Parser für den aktuellen Buffer
            local parser = vim.treesitter.get_parser(bufnr)
            if not parser then
                return nil, nil
            end

            local tree = parser:parse()[1]
            if not tree then
                return nil, nil
            end

            local root = tree:root()
            local node = root:named_descendant_for_range(row, col, row, col)

            -- Gehe nach oben bis wir eine Funktion/Methode finden
            while node do
                local node_type = node:type()
                -- C# und andere Sprachen: method_declaration, function_declaration, etc.
                if node_type == "method_declaration"
                    or node_type == "function_declaration"
                    or node_type == "function_definition"
                    or node_type == "local_function_statement"
                    or node_type == "constructor_declaration"
                    or node_type == "lambda_expression" then
                    local start_row, _, end_row, _ = node:range()
                    return start_row + 1, end_row + 1  -- 1-indexed für Vim
                end
                node = node:parent()
            end
            return nil, nil
        end

        -- zC: Alle inneren Folds in der aktuellen Funktion schließen
        vim.keymap.set("n", "zC", function()
            local start_line, end_line = get_current_function_range()
            if start_line and end_line then
                local save_cursor = vim.api.nvim_win_get_cursor(0)
                local func_foldlevel = vim.fn.foldlevel(start_line)

                -- Setze foldlevel auf das Level der Funktion
                -- Das schließt alle Folds mit höherem Level
                vim.wo.foldlevel = func_foldlevel

                -- Stelle sicher dass die Funktion selbst offen bleibt
                vim.api.nvim_win_set_cursor(0, {start_line, 0})
                pcall(function() vim.cmd("normal! zo") end)

                vim.api.nvim_win_set_cursor(0, save_cursor)
            else
                vim.cmd("normal! zC")
            end
        end, { desc = "Alle Folds in Funktion schließen" })

        -- zO: Alle Folds in der aktuellen Funktion öffnen
        vim.keymap.set("n", "zO", function()
            local start_line, end_line = get_current_function_range()
            if start_line and end_line then
                local save_cursor = vim.api.nvim_win_get_cursor(0)
                -- Setze foldlevel hoch genug um alles zu öffnen
                vim.wo.foldlevel = 99
                vim.api.nvim_win_set_cursor(0, save_cursor)
            else
                vim.cmd("normal! zO")
            end
        end, { desc = "Alle Folds in Funktion öffnen" })
    end
}

return { M }
