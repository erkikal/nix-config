local cfg = ZANEYOS or {}
local window_rules = cfg.windowRules or {}

for _, rule in ipairs(window_rules) do
  if rule.match and next(rule.match) == nil then
    rule.match = nil
  end
  hl.window_rule(rule)
end
