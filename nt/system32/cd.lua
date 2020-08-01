--------------------------------- OpenNT cd.lua --------------------------------
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

local fs = require("fs")
local args = {...}

if #args == 0 then
  print(os.getenv("DRIVE") .. os.getenv("CD"):upper():gsub("[/\\]+", "\\"))
  return
end

local d = args[1]:gsub("[/\\]+", "\\")

if d:sub(1,1) ~= "/" and d:sub(1,1) ~= "\\" then
  d = fs.concat(os.getenv("CD"), d)
end

if fs.exists(d) and fs.isDirectory(d) then
  os.setenv("CD", d)
else
  error("Invalid directory")
end
