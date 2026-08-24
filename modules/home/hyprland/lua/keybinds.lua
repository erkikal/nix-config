local cfg = ZANEYOS or {}
local bindd_entries = cfg.bindd or {}
local bindm_entries = cfg.bindm or {}

-- Chords, modifier expansion and keycode conversion are precomputed in Nix
-- (see hyprland.nix); each entry arrives as { chord, dispatcher, args,
-- description? }. This file only maps the resolved dispatcher to hl.dsp.*.

local function trim(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function direction(value)
  local directions = {
    l = "left",
    r = "right",
    u = "up",
    d = "down",
    left = "left",
    right = "right",
    up = "up",
    down = "down",
  }
  value = trim(value):lower()
  return directions[value] or value
end

local function parse_resize_delta(value)
  local x, y = trim(value):match("^([%-]?%d+)%s+([%-]?%d+)$")
  return tonumber(x), tonumber(y)
end

local function active_window_size()
  if not hl.get_active_window then
    return nil, nil
  end

  local window = hl.get_active_window()
  if not window or not window.size then
    return nil, nil
  end

  local width = tonumber(window.size.x or window.size[1])
  local height = tonumber(window.size.y or window.size[2])
  return width, height
end

local function exec_cmd(cmd)
  return function()
    hl.exec_cmd(cmd)
  end
end

local function dispatch_cmd(dispatcher, args)
  dispatcher = trim(dispatcher):lower()
  args = trim(args)
  if dispatcher == "" then
    return function() end
  end

  if hl.dsp and hl.dispatch then
    if dispatcher == "killactive" and hl.dsp.window and hl.dsp.window.close then
      return function()
        hl.dispatch(hl.dsp.window.close())
      end
    end

    if dispatcher == "exit" and hl.dsp.exit then
      return function()
        hl.dispatch(hl.dsp.exit())
      end
    end

    if dispatcher == "togglefloating" and hl.dsp.window and hl.dsp.window.float then
      return function()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
      end
    end

    if dispatcher == "fullscreen" and hl.dsp.window and hl.dsp.window.fullscreen then
      local mode = args == "1" and "maximized" or "fullscreen"
      return function()
        hl.dispatch(hl.dsp.window.fullscreen({ mode = mode }))
      end
    end

    if dispatcher == "movefocus" and hl.dsp.focus then
      local dir = direction(args)
      return function()
        hl.dispatch(hl.dsp.focus({ direction = dir }))
      end
    end

    if dispatcher == "movewindow" and hl.dsp.window and hl.dsp.window.move then
      local dir = direction(args)
      return function()
        hl.dispatch(hl.dsp.window.move({ direction = dir }))
      end
    end

    if dispatcher == "swapwindow" and hl.dsp.window and hl.dsp.window.swap then
      local dir = direction(args)
      return function()
        hl.dispatch(hl.dsp.window.swap({ direction = dir }))
      end
    end

    if dispatcher == "workspace" and hl.dsp.focus then
      local workspace = tonumber(args) or args
      if workspace == "" then
        return function() end
      end
      return function()
        hl.dispatch(hl.dsp.focus({ workspace = workspace }))
      end
    end

    if dispatcher == "movetoworkspace" and hl.dsp.window and hl.dsp.window.move then
      local workspace = tonumber(args) or args
      if workspace == "" then
        return function() end
      end
      return function()
        hl.dispatch(hl.dsp.window.move({ workspace = workspace }))
      end
    end

    if dispatcher == "togglespecialworkspace" and hl.dsp.workspace and hl.dsp.workspace.toggle_special then
      return function()
        hl.dispatch(hl.dsp.workspace.toggle_special())
      end
    end

    if dispatcher == "layoutmsg" and hl.dsp.layout then
      local message = args
      return function()
        hl.dispatch(hl.dsp.layout(message))
      end
    end

    if dispatcher == "pseudo" and hl.dsp.window and hl.dsp.window.pseudo then
      return function()
        hl.dispatch(hl.dsp.window.pseudo({ action = "toggle" }))
      end
    end

    if dispatcher == "pin" and hl.dsp.window and hl.dsp.window.pin then
      local target = args ~= "" and args or "active"
      return function()
        hl.dispatch(hl.dsp.window.pin({ window = target }))
      end
    end

    if dispatcher == "cyclenext" and hl.dsp.window and hl.dsp.window.cycle_next then
      return function()
        hl.dispatch(hl.dsp.window.cycle_next())
      end
    end

    if dispatcher == "bringactivetotop" and hl.dsp.window and hl.dsp.window.bring_to_top then
      return function()
        hl.dispatch(hl.dsp.window.bring_to_top())
      end
    end

    if (dispatcher == "resizeactive" or dispatcher == "resizewindow")
      and hl.dsp.window
      and hl.dsp.window.resize
    then
      local dx, dy = parse_resize_delta(args)
      if dx and dy then
        return function()
          local current_w, current_h = active_window_size()
          if not current_w or not current_h then
            return
          end
          hl.dispatch(hl.dsp.window.resize({
            x = math.max(1, current_w + dx),
            y = math.max(1, current_h + dy),
          }))
        end
      end
      return function()
        hl.dispatch(hl.dsp.window.resize())
      end
    end
  end

  if hl.dsp and hl.dsp.exec_raw and hl.dispatch then
    local raw = dispatcher
    if args ~= "" then
      raw = raw .. " " .. args
    end
    return function()
      hl.dispatch(hl.dsp.exec_raw(raw))
    end
  end

  return function() end
end

for _, entry in ipairs(bindd_entries) do
  local dispatcher = entry.dispatcher or ""
  if entry.chord and entry.chord ~= "" and dispatcher ~= "" then
    local action
    if dispatcher == "exec" then
      action = exec_cmd(entry.args or "")
    else
      action = dispatch_cmd(dispatcher, entry.args or "")
    end

    local opts = {}
    if entry.description and entry.description ~= "" then
      opts.description = entry.description
    end
    if next(opts) == nil then
      opts = nil
    end

    hl.bind(entry.chord, action, opts)
  end
end

for _, entry in ipairs(bindm_entries) do
  local dispatcher = entry.dispatcher or ""
  if entry.chord and entry.chord ~= "" and dispatcher ~= "" then
    local action
    if dispatcher == "movewindow" and hl.dsp and hl.dsp.window and hl.dsp.window.drag then
      action = hl.dsp.window.drag()
    elseif (dispatcher == "resizeactive" or dispatcher == "resizewindow")
      and hl.dsp
      and hl.dsp.window
      and hl.dsp.window.resize
    then
      action = hl.dsp.window.resize()
    else
      action = dispatch_cmd(dispatcher, entry.args or "")
    end

    local opts = { mouse = true }
    if entry.description and entry.description ~= "" then
      opts.description = entry.description
    end

    hl.bind(entry.chord, action, opts)
  end
end
