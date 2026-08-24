local cfg = ZANEYOS or {}
local monitors = cfg.monitors or {}

for _, spec in ipairs(monitors) do
  -- Skip the empty-output catch-all default, matching prior behavior.
  if spec.output and spec.output ~= "" then
    hl.monitor(spec)
  end
end
