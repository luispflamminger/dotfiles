local wezterm = require 'wezterm';

local os = os.getenv("OS")
local default_prog
if os ~= "LINUX" then
    default_prog = { "ubuntu2204.exe" }
end

return {

    -- Run wsl if on windows
    default_prog = default_prog,

    -- Hide tab bar when there's only one tab
    hide_tab_bar_if_only_one_tab = true,

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
    font = wezterm.font("JetBrains Mono NL"),
    font_size = 13.0,
}
