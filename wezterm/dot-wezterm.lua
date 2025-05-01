local wezterm = require 'wezterm';

-- determine os
if os.getenv("OS") == "LINUX" then
    os = "linux"
else
    -- check for macos using uname
    local pipe = io.popen("uname 2>&1", "r")
    if not pipe then
        error("failed to determine os")
    end
    local out = string.find(pipe:read("*a"), "Darwin")

    if out ~= nil then
        os = "macos"
    else
        os = "windows"
    end
end

local default_prog
if os == "windows" then
    default_prog = { "ubuntu2204.exe" }
end

local font = wezterm.font("JetBrains Mono NL")
if os == "macos" then
    font = wezterm.font("JetBrainsMonoNL Nerd Font")
end

return {

    -- Run wsl if on windows
    default_prog = default_prog,

    -- Set key bindings explicitly
    disable_default_key_bindings = true,
    keys = {
        { -- copy to clipboard
            key = "c",
            mods = "CTRL|SHIFT",
            action = wezterm.action { CopyTo = "Clipboard" },
        },
        { -- paste from clipboard
            key = "v",
            mods = "CTRL|SHIFT",
            action = wezterm.action { PasteFrom = "Clipboard" },
        },
        { -- zoom in
            key = "=",
            mods = "CTRL",
            action = wezterm.action.IncreaseFontSize,
        },
        { -- zoom out
            key = "-",
            mods = "CTRL",
            action = wezterm.action.DecreaseFontSize,
        },
    },

    -- Hide tab bar when there's only one tab
    hide_tab_bar_if_only_one_tab = true,

    -- Disable the bell
    audible_bell = "Disabled",

    -- Do not ask before closing a window
    window_close_confirmation = "NeverPrompt",

    -- Window padding
    window_padding = {
        left = 7,
        right = 7,
        top = 7,
        bottom = 7,
    },

    -- Color scheme
    color_scheme = 'Gruvbox dark, pale (base16)',

    -- Font configuration
    font = font,
    font_size = 13.0,
}
