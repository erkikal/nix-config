local cfg = ZANEYOS or {}
local env_entries = cfg.env or {}

for _, entry in ipairs(env_entries) do
  if entry.key and entry.value then
    hl.env(entry.key, entry.value)
  end
end
