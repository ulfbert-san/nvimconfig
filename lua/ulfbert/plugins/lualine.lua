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
            local function custom_branch()
                local branch = vim.fn.system("git branch --show-current 2>nul")
                branch = vim.trim(branch)
                
                if branch ~= "" and vim.v.shell_error == 0 then
                    return ' 󰘬 ' .. branch
                end
                                
                local head_file = vim.fn.findfile('.git/HEAD', '.;')
                if head_file ~= "" then
                    local head_content = vim.fn.readfile(head_file)
                    if #head_content > 0 then
                        local ref = head_content[1]:match('ref: refs/heads/(.+)')
                        if ref then
                            return ' 󰘬 ' .. ref
                        end
                    end
                end
                
                return ''
            end
            
            -- Custom icon component
            local function filename_icon()
                return '󱚝'
            end
                         
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
                    component_separators = { left = '󰷵', right = '|'},
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
                      refresh_time = 16, -- ~60fps
                      events = {
                        'WinEnter',
                        'BufEnter',
                        'BufWritePost',
                        'SessionLoadPost',
                        'FileChangedShellPost',
                        'VimResized',
                        'Filetype',
                        'CursorMoved',
                        'CursorMovedI',
                        'ModeChanged',
                      },
                    }
                  },
                  sections = {
                    lualine_a = {'mode'},
                    lualine_b = {custom_branch, 'diff', 'diagnostics'},
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

