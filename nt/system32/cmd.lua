-------------------------------- OpenNT cmd.lua --------------------------------
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

-- set up stdio
do
  if io.tmp_stdio then
    io.tmp_stdio.stdout:write("Setting standard I/O.\n")
    io.input(io.tmp_stdio.stdin)
    io.output(io.tmp_stdio.stdout)
    io.tmp_stdio = nil
  end
end

os.setenv("CD", os.getenv("CD") or "/")
local cmd = require("cmdlib")

-- prompt replacements
local prep = {
  ["%$P"] = function() return (os.getenv("DRIVE") or "A:") .. (os.getenv("CD") or "/") end,
  ["%$G"] = function() return ">" end
}
local function parseprompt(ppt)
  for pat, rep in pairs(prep) do
    ppt = ppt:gsub(pat, rep())
  end
  return ppt
end

while true do
  local ppt = os.getenv("PROMPT") or "$P$G "
  io.write(parseprompt(ppt))
  local line = io.read():gsub("\n", "")
  if #line > 0 then
    local ok, err = cmd.execute(line)
    if not ok then
      print("\27[91m" .. err .. "\27[37m")
    end
  end
end
