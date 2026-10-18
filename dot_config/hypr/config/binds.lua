-- Keybindings
--
-- Mirrors the AeroSpace (macOS) bindings in ~/.aerospace.toml, with SUPER in
-- place of Alt. Noctalia, hardware and utility binds from the CachyOS defaults
-- are kept. Conflicting CachyOS defaults were moved:
--   SUPER+J togglesplit  -> SUPER+slash
--   SUPER+L lock         -> SUPER+ALT+L
--   SUPER+Minus/Plus zoom -> SUPER+ALT+Minus/Plus (keypad zoom unchanged)
--   SUPER+Tab window-switcher -> SUPER+grave
--   SUPER+1..3 / SUPER+ALT+n / SUPER+CONTROL+n monitor & workspace loops
--     -> replaced by SUPER+1..0 (workspace) and SUPER+SHIFT+1..0 (move to workspace)

local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())

-- Layout (AeroSpace: alt-slash = tiles, alt-comma = accordion)
hl.bind(mainMod .. " + slash", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + comma", hl.dsp.group.toggle())

-- Change focus (vim keys, AeroSpace alt-h/j/k/l; arrows kept)
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd(noctCall .. "window-switcher"))

-- Move active window (vim keys, AeroSpace alt-shift-h/j/k/l; arrows kept)
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))

-- Move active window across monitors & adjacent workspaces
hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))

-- Resize (AeroSpace: alt-minus / alt-equal = resize smart -50/+50)
hl.bind(mainMod .. " + Minus",         hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + Equal",         hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Minus", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Equal", hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + ALT + Minus", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + ALT + Plus",  function() zoomfunction(0.3) end,  { repeating = true })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })


------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("XF86Calculator",           hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
hl.bind(mainMod .. " + ALT + L",    hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + ALT + C",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Workspaces 1-10 (AeroSpace: alt-1..9, alt-0 / alt-shift-1..9, alt-shift-0)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,            hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i }))
end

-- Back and forth (AeroSpace: alt-tab), move workspace to next monitor (alt-shift-tab)
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.workspace.move({ monitor = "+1" }))

-- Adjacent workspaces and next empty on the current monitor
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",  hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special())

-----------------------
---- SERVICE SUBMAP ----
-----------------------
-- AeroSpace "service" mode. Enter with SUPER+SHIFT+semicolon; every bind below
-- returns to the main map after firing (the "reset" argument), like
-- ['<action>', 'mode main'] in aerospace.toml.

-- Close every window on the active workspace except the focused one
local function close_all_but_current()
    local active = hl.get_active_window()
    if not active or not active.workspace then return end
    for _, w in ipairs(hl.get_workspace_windows(active.workspace)) do
        if w.address ~= active.address then
            hl.dispatch(hl.dsp.window.close({ window = w }))
        end
    end
end

hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.submap("service"))

hl.define_submap("service", "reset", function()
    hl.bind("Escape",    hl.dsp.exec_cmd("hyprctl reload"))          -- reload-config
    hl.bind("R",         hl.dsp.layout("togglesplit"))               -- flatten-workspace-tree (closest dwindle equivalent)
    hl.bind("F",         hl.dsp.window.float({ action = "toggle" })) -- layout floating tiling
    hl.bind("BackSpace", close_all_but_current)                      -- close-all-windows-but-current
    -- join-with <direction>: merge into the neighbouring window's group (or create one)
    hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ into_or_create_group = "left" }))
    hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ into_or_create_group = "down" }))
    hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ into_or_create_group = "up" }))
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ into_or_create_group = "right" }))
end)
