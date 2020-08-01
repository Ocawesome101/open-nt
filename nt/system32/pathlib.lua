local plib = {}

local fs = require("fs")

function plib.localize(d)
  checkArg(1, d, "string")
  d = d:gsub("[/\\]+", "\\")
  if d:sub(1,1) ~= "/" and d:sub(1,1) ~= "\\" then
    d = fs.concat(os.getenv("CD"), d)
  end
  return d
end

function plib.resolve(p)
  local drv, path = p:match("^(.:)(.*)")
  local hax = not (drv and path)
  drv = drv or os.getenv("DRIVE") or "A:"
  path = path or (drv == os.getenv("DRIVE") and os.getenv("CD")) or "\\"
  if hax then path = fs.concat(path, p) end
  return drv, path
end

return plib
