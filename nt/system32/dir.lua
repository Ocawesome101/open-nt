-------------------------------- OpenNT dir.lua --------------------------------
-- Copyright (C) 2020 Ocawesome101                                            --
--                                                                            --
-- This program is free software: you can redistribute it and/or modify       --
-- it under the terms of the GNU General Public License as published by       --
-- the Free Software Foundation, either version 3 of the License, or          --
-- (at your option) any later version.                                        --
--                                                                            --
-- This program is distributed in the hope that it will be useful,            --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of             --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              --
-- GNU General Public License for more details.                               --
--                                                                            --
-- You should have received a copy of the GNU General Public License          --
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.     --
--------------------------------------------------------------------------------

local cmd = require("cmdlib")
local fs = require("fs")

local args, opts = cmd.parse(...)

if #args == 0 then
  args[1] = "\\"
end

local drv = args[1]:match("^(.:)") or os.getenv("DRIVE") or "A:"
local prx = assert(fs.get(drv))

print(string.format("\n\tVolume in drive %s is %s", drv:upper(), prx.getLabel() or prx.address:sub(1,3)))
print(string.format("\tVolume Serial Number is %s", prx.address:sub(1, 13)))
print(string.format("\tDirectory of %s", fs.concat(drv:upper(), args[1]:upper())))
io.write("\n\n")

local files = fs.list(args[1])
if not files then
  error("File not found", 0)
end
table.sort(files)
local maxlen = 0
for i=1, #files, 1 do
  if #files[i] > maxlen then
    maxlen = #files[i]
  end
end
maxlen = maxlen + 6
for i=1, #files, 1 do
  local name, ext = files[i]:match("(.+)%.(.+)")
  name = name or files[i]
  ext = ext or "<DIR>"
  print(string.format("%s%"..(maxlen-#files[i]+(ext == "<DIR>" and 0 or 4)).."s", name:upper(), ext:upper()))
end
