return {
    "kvrohit/rasmus.nvim",
    priority = 1000,
    lazy = true,  -- Deaktiviert, vsdark ist aktiv
    config = function()
        -- Configure appearance
        vim.g.rasmus_italic_comments = true
        vim.g.rasmus_italic_keywords = false
        vim.g.rasmus_italic_booleans = false
        vim.g.rasmus_italic_functions = false
        vim.g.rasmus_italic_variables = false
        
        vim.g.rasmus_bold_comments = false
        vim.g.rasmus_bold_keywords = false
        vim.g.rasmus_bold_booleans = false
        vim.g.rasmus_bold_functions = false
        vim.g.rasmus_bold_variables = false
        
        -- Transparent background
        vim.g.rasmus_transparent = false
        
        -- Variant: "dark" or "monochrome"
        vim.g.rasmus_variant = "dark"
        
        -- Load colorscheme
        vim.cmd([[colorscheme rasmus]])
        
        -- Customize search highlight colors to match operators (orange)
        -- Use autocmd to ensure it's applied after colorscheme is fully loaded
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "rasmus",
            callback = function()
                local operator_hl = vim.api.nvim_get_hl(0, { name = "Operator" })
                if operator_hl.fg then
                    vim.api.nvim_set_hl(0, "Search", { fg = "bg", bg = operator_hl.fg, bold = true })
                    vim.api.nvim_set_hl(0, "IncSearch", { fg = "bg", bg = operator_hl.fg, bold = true })
                    vim.api.nvim_set_hl(0, "CurSearch", { fg = "bg", bg = operator_hl.fg, bold = true })
                end
                
                -- Set variable highlights AFTER colorscheme event
                -- Use defer_fn to ensure colorscheme has finished setting all highlights
                vim.defer_fn(function()
                    local red = "#ff968c"
                    local blue = "#8db4d4"
                    local magenta = "#de9bc8"
                    
                    -- Set all highlights with force=true to override colorscheme
                    vim.api.nvim_set_hl(0, "@variable", { fg = red, force = true })
                    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = blue, force = true })
                    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = magenta, force = true })
                    vim.api.nvim_set_hl(0, "@variable.member", { fg = blue, force = true })
                    vim.api.nvim_set_hl(0, "Identifier", { fg = blue, force = true })
                end, 300)  -- 300ms delay to ensure colorscheme is done
            end,
        })
        
        -- Trigger it immediately for the first load
        vim.schedule(function()
            local operator_hl = vim.api.nvim_get_hl(0, { name = "Operator" })
            if operator_hl.fg then
                vim.api.nvim_set_hl(0, "Search", { fg = "bg", bg = operator_hl.fg, bold = true })
                vim.api.nvim_set_hl(0, "IncSearch", { fg = "bg", bg = operator_hl.fg, bold = true })
                vim.api.nvim_set_hl(0, "CurSearch", { fg = "bg", bg = operator_hl.fg, bold = true })
            end
        end)
        
        -- Set variable highlights AFTER colorscheme is fully loaded
        -- Use defer_fn with a delay to ensure colorscheme has finished setting all highlights
        vim.defer_fn(function()
            local magenta = "#de9bc8"
            
            -- Set all highlights with force=true to override colorscheme
            vim.api.nvim_set_hl(0, "@variable", { fg = magenta, force = true })
            vim.api.nvim_set_hl(0, "@variable.builtin", { fg = magenta, force = true })
            vim.api.nvim_set_hl(0, "@variable.parameter", { fg = magenta, force = true })
            vim.api.nvim_set_hl(0, "@variable.member", { fg = magenta, force = true })
            vim.api.nvim_set_hl(0, "Identifier", { fg = magenta, force = true })
        end, 300)  -- 300ms delay to ensure colorscheme is done
    end
}

