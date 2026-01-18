return {
    {
        "prabirshrestha/asyncomplete.vim",
        config = function()
            -- Asyncomplete configuration mit Performance-Optimierungen
            vim.g.asyncomplete_auto_popup = 1
            vim.g.asyncomplete_auto_completeopt = 0  -- WICHTIG: Verhindert dass asyncomplete completeopt überschreibt

            -- Performance-Optimierungen (Visual Studio Style)
            vim.g.asyncomplete_force_refresh_on_insert = 0  -- Kein Refresh bei jedem Zeichen
            vim.g.asyncomplete_force_refresh_on_context_changed = 0  -- Nur bei echten Änderungen

            -- Caching für bessere Performance (wie Visual Studio)
            vim.g.asyncomplete_cache_enabled = 1
            vim.g.asyncomplete_cache_size = 1000

            -- Zusätzliche Einstellungen für bessere Filterung
            vim.o.ignorecase = true
            vim.o.smartcase = true

            -- Timeout-Einstellungen für bessere Performance (Visual Studio Style)
            vim.g.asyncomplete_popup_delay = 50
            
            -- Globaler Preprocessor für asyncomplete
            vim.api.nvim_create_autocmd("User", {
                pattern = "asyncomplete_setup",
                callback = function()
                    -- Definiere die Preprocessor-Funktion in VimScript
                    vim.cmd([=[
                        function! MyAsyncompletePreprocessor(options, matches) abort
                            let l:visited = {}
                            let l:items = []

                            for [l:source_name, l:matches] in items(a:matches)
                                for l:item in l:matches['items']
                                    if stridx(l:item['word'], a:options['base']) == 0
                                        if !has_key(l:visited, l:item['word'])
                                            call add(l:items, l:item)
                                            let l:visited[l:item['word']] = 1
                                        endif
                                    endif
                                endfor
                            endfor

                            call asyncomplete#preprocess_complete(a:options, l:items)
                        endfunction
                        
                        let g:asyncomplete_preprocessor = [function('MyAsyncompletePreprocessor')]
                        ]=])
                end,
            })
        end
    },
    {
        -- Lokales asyncomplete-omnisharp Plugin
        dir = "C:/Users/Marcel.Lachmann/Repos/asyncomplete-omnisharp",
        name = "asyncomplete-omnisharp",
        config = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "asyncomplete_setup",
                callback = function()
                    -- Custom Completor der NACH der Completion das SignatureHelp schließt
                    local function custom_omnisharp_completor(opt, ctx)
                        -- Erst normale omni-completor Logik ausführen
                        local result = vim.fn["asyncomplete#sources#omni#completor"](opt, ctx)
                        
                        -- DANN: SignatureHelp Popup über OmniSharp schließen (nach der Completion)
                        vim.schedule(function()
                            pcall(vim.fn["OmniSharp#popup#Close"])
                        end)
                        
                        return result
                    end
                    
                    vim.fn["asyncomplete#register_source"](vim.fn["asyncomplete#sources#omni#get_source_options"]({
                        name = 'omnisharp',
                        allowlist = { 'cs', 'csx', 'vb' },
                        blocklist = { 'c', 'cpp', 'html' },
                        completor = custom_omnisharp_completor,  -- Custom Completor verwenden
                        timeout = 1000
                    }))
                end,
            })

            -- Setze completeopt NACH asyncomplete, da es sonst überschrieben wird
            vim.api.nvim_create_autocmd("User", {
                pattern = "asyncomplete_setup",
                callback = function()
                    vim.o.completeopt = "menu,menuone,noinsert,noselect"
                end
            })

            -- Strict Prefix Filtering mit CompleteChanged
            local grp = vim.api.nvim_create_augroup('StrictPrefixPUM', { clear = true })
            local is_filtering = false  -- Flag um Rekursion zu verhindern

            vim.api.nvim_create_autocmd('CompleteChanged', {
                group = grp,
                callback = function()
                    -- Verhindere Rekursion
                    if is_filtering then return end

                    -- Nur eingreifen, wenn Popup sichtbar:
                    if vim.fn.pumvisible() == 0 then return end

                    -- complete_info: holt aktuelle Menü-Items, Modus, Auswahl etc.
                    local info = vim.fn.complete_info({ 'mode', 'items', 'selected' })

                    -- Wenn der User gerade aktiv ein Item selektiert, nicht "zappeln":
                    if info.selected and info.selected >= 0 then return end
                    if not info.items or #info.items == 0 then return end

                    -- Aktuelle Zeile + Cursor
                    local line = vim.api.nvim_get_current_line()
                    local col = vim.fn.col('.')

                    -- Wort-Prefix vor dem Cursor bestimmen
                    local prefix_start = nil
                    local before = line:sub(1, col - 1)
                    local s, e = before:find('%w+$')  -- simple Variante
                    local base, startcol
                    if s then
                        base = before:sub(s, e)
                        startcol = s
                    else
                        base = ''
                        startcol = col
                    end
                    if base == '' then return end

                    -- Striktes Prefix-Filtering (case-insensitive)
                    local lower_base = base:lower()
                    local filtered = {}
                    for _, it in ipairs(info.items) do
                        local w = type(it) == 'table' and (it.word or it.abbr or '') or tostring(it)
                        if w:sub(1, #base):lower() == lower_base then
                            table.insert(filtered, it)
                        end
                    end

                    if #filtered > 0 then
                        is_filtering = true  -- Setze Flag
                        vim.schedule(function()
                            vim.fn.complete(startcol, filtered)
                            is_filtering = false  -- Reset Flag
                        end)
                    end
                end,
            })
        end
    }
}