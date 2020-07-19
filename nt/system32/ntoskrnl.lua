-------------------------------- OpenNT kernel ---------------------------------
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

-- TODO: Possibly split into separate scripts if code gets too large (>~750 lines)?

_G.nt = {} -- the kernel API

nt.gpu = component.proxy(component.list("gpu")())
nt.gpu.bind((component.list("screen")()))

do
  local bsodtext = [[
A problem has been detected and OpenNT has been
shut down to prevent damage to your computer.

The problem seems to be caused by the following
error:
]]

  local function bsod(err)
    local panic = bsodtext .. err
    nt.gpu.setForeground(0xFFFFFF)
    nt.gpu.setBackground(nt.gpu.getDepth() > 1 and 0x0066FF or 0x000000)
    local w, h = nt.gpu.maxResolution()
    nt.gpu.setResolution(w, h)
    nt.gpu.fill(1, 1, w, h, " ")
    local y = 1
    for line in panic:gmatch("[^\n]+") do
      nt.gpu.set(1, y, (line:gsub("\t", "  ")))
      y = y + 1
    end
    while true do
      computer.pullSignal()
    end
  end

  nt.panic = bsod
end

-- wrap most kernel code in a pcall
local ok, err = xpcall(function()

-- kernel logger
do
  local y = 0
  local bmsg = "Starting OpenNT"
  local w, h = nt.gpu.maxResolution()
  nt.gpu.setForeground(0xFFFFFF)
  nt.gpu.setBackground(0x000000)
  nt.gpu.fill(1, 1, w, h, " ")
  nt.gpu.setForeground(0x000000)
  nt.gpu.setBackground(0xbebebe)
  nt.gpu.fill(1, h, w, 1, " ")
  nt.gpu.set((w // 2) - (#bmsg // 2), h, bmsg)
  nt.gpu.setForeground(0xFFFFFF)
  nt.gpu.setBackground(0x000000)
  function nt.log(msg)
    for line in msg:gmatch("[^\n]+") do
      if y > h then
        y = h
        nt.gpu.copy(1, 1, w, h - 1, 0, -1)
        nt.gpu.fill(1, h - 1, w, 1, " ")
      else
        y = y + 1
      end
      nt.gpu.set(1, y, (line:gsub("\t", "  ")))
    end
  end
end

-- base boot-utils, overwritten later
nt.log("Stage 1: early boot")

nt.log("Getting proxy for drive A:/")
local addr = computer.getBootAddress()
local A = component.proxy(addr)

nt.log("Initializing boot utilities")
local function read_file(file)
  local handle = assert(A.open(file))
  local data = ""
  repeat
    local chunk = A.read(handle, math.huge)
    data = data .. (chunk or "")
  until not chunk
  A.close(handle)
  return data
end

function loadfile(file, mode, env)
  local data = read_file(file)
  return load(data, "=" .. file, mode or "bt", env or _G)
end

local function run_file(f,...)
  return loadfile(f)(...)
end

local function run_files(dir, log)
  log = log or nt.log
  local files = A.list(dir)
  table.sort(files)
  for _, file in ipairs(files) do
    log(file)
    run_file(dir .. "/" .. file)
  end
end

nt.log("Loading base kernel")
run_files("/nt/system32/ntoskrnl/", function(n) nt.log("Run file: " .. n:match("%d%d_(.+)%.lua")) end)

end, debug.traceback) -- kernel code ends here

if not ok then
  nt.panic(err)
end

while true do computer.pullSignal() end
