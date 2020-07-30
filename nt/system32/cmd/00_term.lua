--------------------- OpenNT interface 'cmd': 00_term.lua ----------------------
-- A VT100 terminal. I know Windows doesn't actually have one, but it makes   --
-- writing terminal code *so* much easier.                                    --
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
  local vt = require("vtemu")
  local component = require("component")
  local ps = require("ex.ps")
  local vtread, vtwrite, vtclose
  local stdout = {
    read = function()
      error("cannot read from standard output file")
    end,
    write = function(_, d)
      return vtwrite(d)
    end
  }
  local stdin = {
    read = function(_, ...)
      return vtread(...)
    end,
    write = function()
      error("cannot write to standard input file")
    end
  }
  local function setstdio()
    io.input(stdin)
    io.output(stdout)
    io.error(stdout)
  end
  setstdio()
  vtread, vtwrite, vtclose = vt.session(component.gpu, component.gpu.getScreen())
  io.tmp_stdio = {stdin = stdin, stdout = stdout}
  io.write("\27[2JWelcome to OpenNT.\n")
end
