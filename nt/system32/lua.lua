local env = setmetatable({}, {__index=_G})
local run = true
env.exit = function()
  run = false
end
print("Type exit() to exit.")
while run do
  io.write("> ")
  local ok,err = load(io.read(), nil, nil, env)
  if not ok then
    print(err)
  else
    print(pcall(ok))
  end
end
