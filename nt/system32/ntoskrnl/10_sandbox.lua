----------------------- OpenNT kernel: 10_sandbox.lua --------------------------
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

do
  local sb = {
    error = error,
    type = type,
    table = nt.ke.tcopy(table),
    rawequal = rawequal,
    require = require,
    load = function(x,n,m,e) return load(x,n,m,e or sb) end,
    loadfile = function(f,n,e) return loadfile(f,n,e or sb) end,
    package = nt.ke.tcopy(package),
    pcall = pcall,
    rawlen = rawlen,
    next = next,
    rawget = rawget,
    _OSVERSION = _OSVERSION,
    select = select,
    pairs = pairs,
    utf8 = utf8 and nt.ke.tcopy(utf8),
    io = nt.tcopy(io),
    checkArg = checkArg,
    tostring = tostring,
    ipairs = ipairs,
    coroutine = nt.ke.tcopy(coroutine),
    _VERSION = _VERSION,
    setmetatable = setmetatable,
    os = nt.ke.tcopy(os),
    getmetatable = getmetatable,
    tonumber = tonumber,
    assert = assert,
    dofile = function(f) return assert(loadfile(f,nil,sb))() end,
    debug = nt.ke.tcopy(debug),
    math = nt.ke.tcopy(math),
    string = nt.ke.tcopy(string),
    rawset = rawset,
    xpcall = xpcall
  }

  sb._G = sb
  sb.table.copy = nt.ke.tcopy

  nt.ki.sandbox = sb
end
