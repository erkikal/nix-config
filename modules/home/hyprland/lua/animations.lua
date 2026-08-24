local cfg = ZANEYOS or {}
local animation_cfg = cfg.animation or {}
local bezier_entries = animation_cfg.bezier or {}
local animation_entries = animation_cfg.animation or {}

hl.config({
  animations = {
    enabled = animation_cfg.enabled ~= false,
  },
})

for _, curve in ipairs(bezier_entries) do
  hl.curve(curve.name, {
    type = "bezier",
    points = curve.points,
  })
end

for _, entry in ipairs(animation_entries) do
  hl.animation(entry)
end
