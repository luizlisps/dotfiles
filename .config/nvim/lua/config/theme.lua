local opt = vim.opt

local function system_background()
    if vim.fn.has("macunix") == 1 or vim.fn.has("mac") == 1 then
        local style = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
        if style:lower():match("dark") then
            return "dark"
        end
    end

    return "light"
end

local switcher_dir = vim.fn.stdpath("config"):gsub("/nvim$", "") .. "/theme-switcher"
local active_theme_lines = vim.fn.readfile(switcher_dir .. "/current", "", 1)
local active_theme_id = active_theme_lines[1] or "web"
local themes = dofile(switcher_dir .. "/themes.lua")
local theme = assert(themes[active_theme_id], "Unknown theme: " .. active_theme_id)
local background

local function apply_theme(next_background)
    if next_background == background then
        return
    end

    background = next_background
    opt.background = background
    vim.cmd.colorscheme(theme.colorscheme)
end

local function refresh_system_theme()
    apply_theme(system_background())
end

refresh_system_theme()
vim.api.nvim_create_autocmd("FocusGained", { callback = refresh_system_theme })

local preferences_dir = vim.fn.expand("~/Library/Preferences")
if vim.fn.isdirectory(preferences_dir) == 1 then
    local watcher = vim.uv.new_fs_event()
    local started = watcher:start(preferences_dir, {}, function(err, filename)
        if not err and (filename == nil or filename == ".GlobalPreferences.plist") then
            vim.schedule(refresh_system_theme)
        end
    end)

    if started then
        vim.api.nvim_create_autocmd("VimLeavePre", {
            once = true,
            callback = function()
                watcher:stop()
                watcher:close()
            end,
        })
    else
        watcher:close()
    end
end
