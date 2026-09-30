#!/usr/bin/env luajit

local home = assert(os.getenv("HOME"), "HOME is not set")
local config_dir = home .. "/.config"
local switcher_dir = config_dir .. "/theme-switcher"
local state_file = switcher_dir .. "/current"
local themes = dofile(switcher_dir .. "/themes.lua")

local function fail(message, code)
    io.stderr:write("theme-switcher: " .. message .. "\n")
    os.exit(code or 1)
end

local function read_file(path, optional)
    local file, err = io.open(path, "rb")
    if not file then
        if optional then
            return nil
        end
        error("cannot read " .. path .. ": " .. tostring(err), 0)
    end

    local contents = file:read("*a")
    file:close()
    return contents
end

local function file_exists(path)
    local file = io.open(path, "rb")
    if not file then
        return false
    end
    file:close()
    return true
end

local function safe_name(value)
    return type(value) == "string" and value:match("^[a-zA-Z0-9][a-zA-Z0-9_-]*$") ~= nil
end

local function validate_theme(id, theme)
    if not id:match("^[a-z0-9][a-z0-9-]*$") then
        error("invalid theme id: " .. tostring(id), 0)
    end
    if type(theme) ~= "table" or type(theme.label) ~= "string" or theme.label == "" then
        error("theme " .. id .. " must have a non-empty label", 0)
    end
    if theme.label:find("[\t\r\n]") then
        error("theme label cannot contain tabs or newlines: " .. id, 0)
    end
    if not safe_name(theme.colorscheme) then
        error("theme " .. id .. " has an invalid Neovim colorscheme", 0)
    end

    for _, app in ipairs({ "ghostty", "yazi" }) do
        local variants = theme[app]
        if type(variants) ~= "table" then
            error("theme " .. id .. " is missing " .. app .. " variants", 0)
        end
        for _, variant in ipairs({ "light", "dark" }) do
            if not safe_name(variants[variant]) then
                error("theme " .. id .. " has an invalid " .. app .. " " .. variant .. " name", 0)
            end
        end
    end

    for _, variant in ipairs({ "light", "dark" }) do
        local paths = {
            config_dir .. "/ghostty/themes/" .. theme.ghostty[variant],
            config_dir .. "/yazi/flavors/" .. theme.yazi[variant] .. ".yazi/flavor.toml",
            switcher_dir .. "/themes/" .. id .. "/starship-" .. variant .. ".toml",
            switcher_dir .. "/themes/" .. id .. "/tmux-" .. variant .. ".conf",
            home .. "/.hermes/skins/" .. id .. "-" .. variant .. ".yaml",
        }
        for _, path in ipairs(paths) do
            if not file_exists(path) then
                error("theme " .. id .. " is missing required file " .. path, 0)
            end
        end
    end

    if type(theme.palette) ~= "table" or type(theme.palette.light) ~= "table" or type(theme.palette.dark) ~= "table" then
        error("theme " .. id .. " must define light and dark Neovim palettes", 0)
    end
end

local ids = {}
for id, theme in pairs(themes) do
    validate_theme(id, theme)
    ids[#ids + 1] = id
end
if #ids == 0 then
    error("no themes are configured", 0)
end

table.sort(ids, function(left, right)
    local left_label = themes[left].label:lower()
    local right_label = themes[right].label:lower()
    if left_label == right_label then
        return left < right
    end
    return left_label < right_label
end)

local function active_theme()
    local contents = read_file(state_file, true)
    local id = contents and contents:match("^([^\r\n]+)") or "sunbather"
    if not themes[id] then
        error("unknown active theme in " .. state_file .. ": " .. tostring(id), 0)
    end
    return id
end

local function replace_assignment(contents, section, key, value)
    local output = {}
    local matches = 0
    local in_section = section == nil
    local position = 1

    while position <= #contents do
        local newline = contents:find("\n", position, true)
        local line = newline and contents:sub(position, newline - 1) or contents:sub(position)
        local ending = newline and "\n" or ""
        local carriage_return = line:sub(-1) == "\r" and "\r" or ""
        local clean_line = carriage_return ~= "" and line:sub(1, -2) or line

        if section then
            local heading = clean_line:match("^%s*%[([^%]]+)%]%s*$")
            if heading then
                in_section = heading == section
            end
        end

        if in_section and clean_line:match("^%s*" .. key .. "%s*=") then
            local indent = clean_line:match("^(%s*)") or ""
            line = indent .. key .. " = " .. value .. carriage_return
            matches = matches + 1
        end

        output[#output + 1] = line .. ending
        position = newline and newline + 1 or #contents + 1
    end

    if matches ~= 1 then
        error("expected one " .. key .. " assignment" .. (section and " in [" .. section .. "]" or "") .. ", found " .. matches, 0)
    end
    return table.concat(output)
end

local function temporary_path(path)
    return path .. ".tmp." .. tostring(os.time()) .. "." .. tostring(math.random(100000, 999999))
end

local function stage_file(path, contents)
    local temp_path = temporary_path(path)
    local file, err = io.open(temp_path, "wb")
    if not file then
        return nil, "cannot create " .. temp_path .. ": " .. tostring(err)
    end

    local written, write_err = file:write(contents)
    local closed, close_err = file:close()
    if not written or not closed then
        os.remove(temp_path)
        return nil, "cannot write " .. temp_path .. ": " .. tostring(write_err or close_err)
    end
    return temp_path
end

local function cleanup_staged(changes)
    for _, change in ipairs(changes) do
        if change.temp then
            os.remove(change.temp)
        end
    end
end

local function restore_file(change)
    if change.old == nil then
        return os.remove(change.path)
    end

    local temp_path, err = stage_file(change.path, change.old)
    if not temp_path then
        return nil, err
    end
    local ok, rename_err = os.rename(temp_path, change.path)
    if not ok then
        os.remove(temp_path)
        return nil, rename_err
    end
    return true
end

local function tmux_quote(value)
    return '"' .. value:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

local function apply_theme(id)
    local theme = themes[id]
    if not theme then
        error("unknown theme: " .. tostring(id), 0)
    end

    local ghostty_path = config_dir .. "/ghostty/config"
    local yazi_path = config_dir .. "/yazi/theme.toml"
    local ghostty = replace_assignment(
        read_file(ghostty_path),
        nil,
        "theme",
        "light:" .. theme.ghostty.light .. ",dark:" .. theme.ghostty.dark
    )
    local yazi = read_file(yazi_path)
    yazi = replace_assignment(yazi, "flavor", "light", '"' .. theme.yazi.light .. '"')
    yazi = replace_assignment(yazi, "flavor", "dark", '"' .. theme.yazi.dark .. '"')
    local tmux_selector_path = switcher_dir .. "/current-tmux.conf"
    local starship_dark = tmux_quote(switcher_dir .. "/themes/" .. id .. "/starship-dark.toml")
    local starship_light = tmux_quote(switcher_dir .. "/themes/" .. id .. "/starship-light.toml")
    local tmux_selector = table.concat({
        "if-shell 'defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark' \\",
        "    'source-file ~/.config/theme-switcher/themes/" .. id .. "/tmux-dark.conf; set-environment -g STARSHIP_CONFIG " .. starship_dark .. "' \\",
        "    'source-file ~/.config/theme-switcher/themes/" .. id .. "/tmux-light.conf; set-environment -g STARSHIP_CONFIG " .. starship_light .. "'",
        "",
    }, "\n")

    local changes = {}
    local function add_change(path, updated)
        local old = read_file(path, true)
        if old ~= updated then
            changes[#changes + 1] = { path = path, old = old, updated = updated }
        end
    end

    add_change(ghostty_path, ghostty)
    add_change(yazi_path, yazi)
    add_change(tmux_selector_path, tmux_selector)
    add_change(state_file, id .. "\n")

    for _, change in ipairs(changes) do
        local temp_path, err = stage_file(change.path, change.updated)
        if not temp_path then
            cleanup_staged(changes)
            error(err, 0)
        end
        change.temp = temp_path
    end

    local committed = 0
    for index, change in ipairs(changes) do
        local ok, err = os.rename(change.temp, change.path)
        if not ok then
            cleanup_staged(changes)
            local rollback_errors = {}
            for previous = committed, 1, -1 do
                local restored, restore_err = restore_file(changes[previous])
                if not restored then
                    rollback_errors[#rollback_errors + 1] = tostring(restore_err)
                end
            end
            local message = "cannot replace " .. change.path .. ": " .. tostring(err)
            if #rollback_errors > 0 then
                message = message .. "; rollback failures: " .. table.concat(rollback_errors, "; ")
            end
            error(message, 0)
        end
        change.temp = nil
        committed = index
    end

    if os.getenv("TMUX") then
        local reloaded = os.execute('tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 && tmux refresh-client -S >/dev/null 2>&1')
        if reloaded ~= 0 and reloaded ~= true then
            io.stderr:write("theme-switcher: tmux reload failed; use prefix+r to load the saved theme\n")
        end
    end
    io.stdout:write("Tema aplicado: " .. theme.label .. " (" .. id .. ")\n")
end

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function choose_theme(current)
    local available = os.execute("command -v fzf >/dev/null 2>&1")
    if available ~= 0 and available ~= true then
        error("fzf is required for interactive selection", 0)
    end

    local rows = {}
    for _, id in ipairs(ids) do
        local label = themes[id].label
        if id == current then
            label = label .. "  (current)"
        end
        rows[#rows + 1] = "[" .. id .. "] " .. label
    end

    local quoted_rows = {}
    for _, row in ipairs(rows) do
        quoted_rows[#quoted_rows + 1] = shell_quote(row)
    end
    local command = "printf '%s\\n' " .. table.concat(quoted_rows, " ")
        .. " | fzf --height=40% --layout=reverse --border"
        .. " --prompt='Theme > ' --header='Enter: apply | Esc: cancel'"

    local pipe, err = io.popen(command, "r")
    if not pipe then
        error("cannot start fzf: " .. tostring(err), 0)
    end
    local selected = pipe:read("*l")
    local ok, _, code = pipe:close()
    if not selected then
        if ok == true or code == 1 or code == 130 then
            return nil
        end
        error("fzf exited without a selection", 0)
    end

    local id = selected:match("^%[([a-z0-9-]+)%]")
    if not id or not themes[id] then
        error("fzf returned an invalid theme selection", 0)
    end
    return id
end

local function print_help()
    io.stdout:write([[
Usage: theme-switcher [--list | --current | --select ID]

Without arguments, opens the fzf theme selector. Add themes in
~/.config/theme-switcher/themes.lua and provide each app's light/dark assets.
Requires LuaJIT and fzf.
]])
end

local function main(arguments)
    local current = active_theme()
    local command = arguments[1]

    if not command then
        local id = choose_theme(current)
        if id then
            apply_theme(id)
        end
        return
    end

    if command == "--help" or command == "-h" then
        print_help()
    elseif command == "--list" and #arguments == 1 then
        for _, id in ipairs(ids) do
            io.stdout:write(id .. "\t" .. themes[id].label .. "\n")
        end
    elseif command == "--current" and #arguments == 1 then
        io.stdout:write(current .. "\n")
    elseif command == "--select" and #arguments == 2 then
        apply_theme(arguments[2])
    else
        fail("invalid arguments; use --help for usage", 2)
    end
end

local ok, err = pcall(main, arg)
if not ok then
    fail(tostring(err))
end
