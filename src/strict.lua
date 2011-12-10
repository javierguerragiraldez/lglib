--
-- strict.lua
-- checks uses of undeclared global variables
-- All global variables must be 'declared' through a regular assignment
-- (even assigning nil will do) in a main chunk before being used
-- anywhere or assigned to inside a function.
--

local getinfo, error, rawset, rawget = debug.getinfo, error, rawset, rawget

local mt = getmetatable(_G) or {}
mt.__declared = {}

local M = {}
function M.on()
	setmetatable (_G, mt)
end
function M.off()
	setmetatable (_G, nil)
end

local function _post(p,...)
	p()
	return ...
end

function M.call(f,...)
	M.on()
	return _post(M.off, f(...))
end

function M.wrap(f)
	return function ()
		M.on()
		f()
		M.off()
	end
end

local function what ()
  local d = getinfo(3, "S")
  return d and d.what or "C"
end

mt.__newindex = function (t, n, v)
  if not mt.__declared[n] then
    local w = what()
    if w ~= "main" and w ~= "C" then
      error("assign to undeclared variable '"..n.."'.", 2)
    end
    mt.__declared[n] = true
  end
  rawset(t, n, v)
end
  
mt.__index = function (t, n)
  if not mt.__declared[n] and what() ~= "C" then
    --print(("[WARNING] variable '%s' in table '%s' is not declared."):format(n, tostring(t)))
    --error("variable '"..n.."' is not declared", 2)
  end
  return rawget(t, n)
end

M.on()
return M