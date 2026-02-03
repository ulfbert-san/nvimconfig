return {
    {
        "puremourning/vimspector",
        config = function()
            -- Funktion: Lese AssemblyName aus .csproj (falls vorhanden)
            local function get_assembly_name(csproj_path)
                local file = io.open(csproj_path, "r")
                if not file then return nil end

                local content = file:read("*a")
                file:close()

                -- Suche nach <AssemblyName>...</AssemblyName>
                local assembly_name = content:match("<AssemblyName>([^<]+)</AssemblyName>")
                return assembly_name
            end

            -- Funktion: Prüfe ob es ein Web-Projekt ist
            local function is_web_project(csproj_path)
                local file = io.open(csproj_path, "r")
                if not file then return false end

                local content = file:read("*a")
                file:close()

                -- Web SDK erkennen
                local is_web = content:find('Sdk="Microsoft.NET.Sdk.Web"', 1, true) ~= nil
                return is_web
            end

            -- Funktion: Prüfe ob es ein WinUI 3 Projekt ist
            local function is_winui_project(csproj_path)
                local file = io.open(csproj_path, "r")
                if not file then return false end

                local content = file:read("*a")
                file:close()

                -- WinUI erkennen: <UseWinUI>true</UseWinUI>
                local is_winui = content:find('<UseWinUI>true</UseWinUI>', 1, true) ~= nil
                return is_winui
            end

            -- Funktion: Lese Launch-Settings aus launchSettings.json
            local function get_launch_settings(project_path)
                local launch_settings_path = project_path .. "\\Properties\\launchSettings.json"
                local file = io.open(launch_settings_path, "r")
                if not file then return nil end

                local content = file:read("*a")
                file:close()

                -- BOM entfernen falls vorhanden
                content = content:gsub("^\239\187\191", "")  -- UTF-8 BOM

                -- Versuche JSON zu parsen
                local ok, settings = pcall(vim.fn.json_decode, content)
                if not ok then return nil end
                if not settings or not settings.profiles then return nil end

                -- Suche nach Profil mit applicationUrl (bevorzuge "https" Profil)
                local profile = settings.profiles["https"] or settings.profiles["http"]

                -- Falls nicht gefunden, nimm das erste Profil mit applicationUrl
                if not profile or not profile.applicationUrl then
                    for _, p in pairs(settings.profiles) do
                        if p.applicationUrl then
                            profile = p
                            break
                        end
                    end
                end

                if not profile or not profile.applicationUrl then return nil end

                local application_url = profile.applicationUrl  -- Kann mehrere URLs enthalten (;-getrennt)
                local base_url = application_url:match("([^;]+)")  -- Erste URL für Browser
                local launch_path = profile.launchUrl or ""

                local browser_url
                if launch_path ~= "" then
                    browser_url = base_url .. "/" .. launch_path
                else
                    browser_url = base_url
                end

                return {
                    application_url = application_url,  -- Für ASPNETCORE_URLS
                    browser_url = browser_url,          -- Für Browser-Öffnung
                }
            end

            -- Funktion: Finde alle .csproj Dateien im aktuellen Verzeichnis
            local function find_csproj_files()
                local cwd = vim.fn.getcwd()
                local projects = {}

                -- Suche nach .csproj Dateien
                local handle = io.popen('dir /s /b "' .. cwd .. '\\*.csproj" 2>nul')
                if handle then
                    for line in handle:lines() do
                        local name = line:match("([^\\]+)%.csproj$")
                        if name then
                            local assembly_name = get_assembly_name(line) or name
                            local project_path = line:match("(.+)\\[^\\]+$")
                            local launch_settings = get_launch_settings(project_path)
                            table.insert(projects, {
                                name = name,
                                assembly_name = assembly_name,
                                path = project_path,
                                csproj = line,
                                is_web = is_web_project(line),
                                is_winui = is_winui_project(line),
                                application_url = launch_settings and launch_settings.application_url,
                                browser_url = launch_settings and launch_settings.browser_url,
                            })
                        end
                    end
                    handle:close()
                end
                return projects
            end

            -- Funktion: Finde die DLL/EXE nach dem Build
            local function find_executable(project_path, assembly_name)
                local search_path = project_path .. "\\bin\\Debug"

                -- Suche nach .dll
                local handle = io.popen('dir /s /b "' .. search_path .. '\\' .. assembly_name .. '.dll" 2>nul')
                if handle then
                    local dll = handle:read("*l")
                    handle:close()
                    if dll then return dll end
                end

                -- Suche nach .exe
                handle = io.popen('dir /s /b "' .. search_path .. '\\' .. assembly_name .. '.exe" 2>nul')
                if handle then
                    local exe = handle:read("*l")
                    handle:close()
                    if exe then return exe end
                end

                return nil
            end

            -- Hauptfunktion: Build und Debug
            local function build_and_debug()
                local projects = find_csproj_files()

                if #projects == 0 then
                    vim.notify("Keine .csproj Dateien gefunden!", vim.log.levels.ERROR)
                    return
                end

                -- Projektauswahl anzeigen
                local choices = {}
                for i, p in ipairs(projects) do
                    table.insert(choices, i .. ". " .. p.name)
                end

                vim.ui.select(choices, { prompt = "Projekt zum Debuggen auswählen:" }, function(choice)
                    if not choice then return end

                    local idx = tonumber(choice:match("^(%d+)"))
                    local project = projects[idx]

                    vim.notify("Baue " .. project.name .. "...", vim.log.levels.INFO)

                    -- Build ausführen
                    local build_cmd = 'dotnet build "' .. project.path .. '\\' .. project.name .. '.csproj" --configuration Debug'
                    local build_result = vim.fn.system(build_cmd)

                    if vim.v.shell_error ~= 0 then
                        vim.notify("Build fehlgeschlagen!\n" .. build_result, vim.log.levels.ERROR)
                        return
                    end

                    vim.notify("Build erfolgreich!", vim.log.levels.INFO)

                    -- DLL/EXE finden (nutzt assembly_name)
                    local dll_path = find_executable(project.path, project.assembly_name)

                    if not dll_path then
                        vim.notify("DLL nicht gefunden nach Build!", vim.log.levels.ERROR)
                        return
                    end

                    -- Umgebungsvariablen vorbereiten
                    local env = {
                        ASPNETCORE_ENVIRONMENT = "Development",
                        DOTNET_ENVIRONMENT = "Development",
                    }

                    -- Für Web-Projekte: ASPNETCORE_URLS setzen
                    if project.is_web and project.application_url then
                        env.ASPNETCORE_URLS = project.application_url
                    end

                    -- Für WinUI-Projekte: .exe verwenden und cwd auf bin-Verzeichnis setzen
                    local program_path = dll_path
                    local working_dir = project.path

                    if project.is_winui then
                        -- WinUI braucht die .exe (nicht .dll) und cwd muss das bin-Verzeichnis sein
                        program_path = dll_path:gsub("%.dll$", ".exe")
                        working_dir = dll_path:match("(.+)\\[^\\]+$")  -- Verzeichnis der DLL/EXE
                        vim.notify("WinUI-Projekt erkannt: " .. project.name, vim.log.levels.INFO)
                    end

                    -- Vimspector Konfiguration dynamisch erstellen
                    local config = {
                        configurations = {
                            ["C# Debug"] = {
                                adapter = "netcoredbg",
                                configuration = {
                                    request = "launch",
                                    program = program_path,
                                    cwd = working_dir,
                                    stopAtEntry = false,
                                    env = env,
                                }
                            }
                        }
                    }

                    -- Temporäre .vimspector.json schreiben
                    local vimspector_path = vim.fn.getcwd() .. "/.vimspector.json"
                    local file = io.open(vimspector_path, "w")
                    if file then
                        file:write(vim.fn.json_encode(config))
                        file:close()
                    end

                    -- Debug-Info anzeigen
                    vim.notify("is_web: " .. tostring(project.is_web) .. ", url: " .. tostring(project.application_url), vim.log.levels.INFO)

                    -- Vimspector starten
                    vim.cmd("call vimspector#Launch()")

                    -- Browser öffnen für Web-Projekte (mit Verzögerung für Server-Start)
                    if project.is_web and project.browser_url then
                        vim.defer_fn(function()
                            vim.notify("Öffne Browser: " .. project.browser_url, vim.log.levels.INFO)
                            vim.fn.system('start "" "' .. project.browser_url .. '"')
                        end, 5000)  -- 5 Sekunden warten bis Server bereit ist
                    end
                end)
            end

            -- Keymaps
            vim.keymap.set("n", "<leader>dr", build_and_debug, { desc = "Build & Debug C#" })
            vim.keymap.set("n", "<leader>dn", "<Plug>VimspectorStepOver")
            vim.keymap.set("n", "<leader>ds", "<Plug>VimspectorStepInto")
            vim.keymap.set("n", "<leader>df", "<Plug>VimspectorStepOut")
            vim.keymap.set("n", "<leader>dc", "<Plug>VimspectorContinue")
            vim.keymap.set("n", "<leader>db", "<Plug>VimspectorToggleBreakpoint", { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dx", ":VimspectorReset<CR>", { desc = "Stop Debugger" })
        end
    }
}
