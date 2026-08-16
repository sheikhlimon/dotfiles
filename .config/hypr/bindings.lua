-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- Unbind Omarchy defaults that conflict with our custom shortcuts
hl.unbind("SUPER + C") -- Was: Universal copy (used for VS Code)
hl.unbind("SUPER + W") -- Was: Close window (using SUPER+Q instead)
hl.unbind("SUPER + X") -- Was: Universal cut (used for X app)
hl.unbind("SUPER + L") -- Was: Toggle workspace layout
hl.unbind("SUPER + SPACE") -- Was: Root menu
hl.unbind("SUPER + ALT + SPACE") -- Was: Apps menu
hl.unbind("SUPER + RETURN") -- Was: Default terminal
hl.unbind("SUPER + CTRL + RETURN") -- Was: Default Herdr

-- Menus: Super+Space for Applications, Super+Alt+Space for Main Root Menu
o.bind("SUPER + SPACE", "Applications menu", "omarchy-menu toggle apps")
o.bind("SUPER + ALT + SPACE", "Main menu", "omarchy-menu toggle root")

-- Custom Application shortcuts
o.bind("SUPER + E", "File manager", { launch = "nautilus --new-window" })
o.bind("SUPER + B", "Browser", { launch = "vivaldi-stable --new-window --ozone-platform=wayland" })
o.bind("SUPER + D", "Docker", { launch = "kitty -e lazydocker" })
o.bind("SUPER + C", "VS Code", { launch = "code" })
o.bind("SUPER + H", "Pomodoro Timer", { launch = "gnome-pomodoro" })

-- Always use Kitty for interactive shell (with CWD detection) and Herdr
o.bind("SUPER + RETURN", "Terminal", { launch = "sh -c 'exec kitty --directory \"$(omarchy-cmd-terminal-cwd)\"'" })
o.bind("SUPER + CTRL + RETURN", "Herdr", { launch = "kitty -- herdr" })

-- Web Apps
o.bind("SUPER + A", "ChatGPT", { webapp = "https://chatgpt.com" })
o.bind("SUPER + Y", "YouTube", { webapp = "https://youtube.com/" })
o.bind("SUPER + X", "X", { webapp = "https://x.com/" })

-- Window management
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + M", "Maximize window", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + L", "Cycle to next window", hl.dsp.window.cycle_next())

-- Reference Examples:
-- See current bindings and descriptions: omarchy menu keybindings --print
-- To disable every Omarchy default binding: omarchy_default_bindings = false
-- To disable all preinstalled app/webapp bindings: omarchy_preinstalled_bindings = false
-- Add a new binding: o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")
-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")


