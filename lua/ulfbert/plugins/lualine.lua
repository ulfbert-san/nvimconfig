return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                config = function()
                    require('nvim-web-devicons').setup({
                        override = {
                            cs = {
                                icon = "󰌛",
                                color = "#00A86A",  -- Grün - ändern Sie nach Belieben
                                cterm_color = "10",
                                name = "Cs"
                            }
                        }
                    })
                end
            }
        },
        config = function()
            -- Cache für Branch-Name (wird nur bei BufEnter/FocusGained aktualisiert)
            local cached_branch = ''
            local cached_branch_display = ''
            local cached_branch_color = { fg = '#00A86A' }

            local function update_branch_cache()
                -- Nur .git/HEAD lesen, KEIN Shell-Aufruf
                local head_file = vim.fn.findfile('.git/HEAD', '.;')
                if head_file ~= "" then
                    local ok, head_content = pcall(vim.fn.readfile, head_file)
                    if ok and #head_content > 0 then
                        local ref = head_content[1]:match('ref: refs/heads/(.+)')
                        if ref then
                            cached_branch = ref
                            cached_branch_display = ' 󰘬 ' .. ref
                            if ref == 'main' or ref == 'master' then
                                cached_branch_color = { fg = '#F7819F' }  -- Rot
                            else
                                cached_branch_color = { fg = '#00A86A' }  -- Grün
                            end
                            return
                        end
                    end
                end
                cached_branch = ''
                cached_branch_display = ''
                cached_branch_color = { fg = '#00A86A' }
            end

            -- Cache beim Start und bei Buffer/Focus-Wechsel aktualisieren
            update_branch_cache()
            vim.api.nvim_create_autocmd({'BufEnter', 'FocusGained', 'DirChanged'}, {
                callback = update_branch_cache
            })

            local function custom_branch()
                return cached_branch_display
            end

            local function branch_color()
                return cached_branch_color
            end

            -- Statischer Icon-String (keine Funktion nötig)
            local robot_icon = '󰈸'
                         
            local colors = {
                bg       = '#1F1F1F',
                fg       = '#D6D6D6',
                gray     = '#545454',
                cyan     = '#4EC9B0',
                red      = '#F7819F',
                green    = '#8FBF7F',
                yellow   = '#EFD879',
                blue     = '#739CC2',
                magenta  = '#C397D8',
            }

            local custom_theme = {
                normal = {
                    a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
                    b = { fg = colors.fg, bg = colors.gray },
                    c = { fg = colors.fg, bg = colors.bg },
                },
                insert = {
                    a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
                    b = { fg = colors.yellow, bg = colors.gray },
                },
                visual = {
                    a = { fg = colors.bg, bg = colors.magenta, gui = 'bold' },
                    b = { fg = colors.yellow, bg = colors.gray },
                },
                replace = {
                    a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
                    b = { fg = colors.yellow, bg = colors.gray },
                },
                command = {
                    a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
                    b = { fg = colors.yellow, bg = colors.gray },
                },
                inactive = {
                    a = { fg = colors.fg, bg = colors.gray },
                    b = { fg = colors.fg, bg = colors.gray },
                    c = { fg = colors.fg, bg = colors.bg },
                },
            }
            
            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = custom_theme,
                    component_separators = { left = '', right = '|'},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {
                      statusline = {},
                      winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                      statusline = 1000,
                      tabline = 1000,
                      winbar = 1000,
                    }
                  },
                  sections = {
                    lualine_a = {'mode'},
                    lualine_b = {
                        { custom_branch, color = branch_color },
                        { function() return robot_icon end, color = { fg = '#FFFFFF' } },  -- Weiß
                        {
                            'diff',
                            diff_color = {
                                added    = { fg = '#00A86A' },  -- Kräftiges Grün
                                modified = { fg = '#1E90FF' },  -- Kräftiges Blau
                                removed  = { fg = '#FF4500' },  -- Kräftiges Rot-Orange
                            },
                        },
                        'diagnostics'
                    },
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                  },
                  inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                  },
                  tabline = {},
                  winbar = {},
                  inactive_winbar = {},
                  extensions = {}
            })
        end
    }
}

