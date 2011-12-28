local string, table = string, table
local tinsert, tremove, tconcat, tsort = table.insert, table.remove, table.concat,table.sort
local List = require('lglib.list')

module(..., package.seeall)

-- this is a Dict prototype, and all instances of Dict must inherit it
local Dict = {}

--itself as its metatable
Dict.__index = Dict
Dict.__typename = "Dict"


--
local function is_key(self, key)
	local list_len = #self
	if type(key) ~= 'number' or (type(key) == 'number' and key > list_len) then
		return true
	else
		return false
	end
end

-- constructor for Dict objects
local function new (tbl)
	-- if tbl is nil，then empty table returned
	local t = {}

	-- only separate the dictionary part from the lua-table as input
	-- seems repeated coding w.r.t. table.lua
	-- just directly call table.takeAparts(tbl)---->dict part
	if tbl then
		checkType(tbl, 'table')
		for k, v in pairs(tbl) do
			if is_key(tbl, k) then
				t[k] = v
			end
		end
	end

	return setmetatable(t, Dict)
end

-- binding constructor new(tbl) with Dict sytanx
-- table can be accessed via __index from its/Dict metatable
setmetatable(Dict, {
    __call = function (self, tbl)
        return new(tbl)
    end,
	__index = table
})

--[[
suggestion:
you can make sure/guarantee that the dict feature of instances can be kept all the way.
delete the is_key() method,
add insert()/delete() for checking the dict feature
add extra length parameter when initialization
or table tt["abc"] = "cde" and tt["cba"] = nil
--]]

-- collecting all keys of Dict and puting them into a List
function Dict:keys()
	local res = List()
	for key, _ in pairs(self) do
		-- select the keys with the dictionary type
		if is_key(self, key) then
			tinsert(res, key)
		end
	end
	return res
end

function Dict:hasKey(key)
    for k, _ in pairs(self) do
		if is_key(self, k) and k == key then
            return true
        end
	end
	return false
end

function Dict:size()
	local count = 0
	for key in pairs(self) do
		if is_key(self, key) then
			count = count + 1
		end
	end
	return count
end

function Dict:values()
	local res = List()
	for key, v in pairs(self) do
		-- select the keys with the dictionary type
		if is_key(self, key) then
			tinsert(res, v)
		end
	end
	return res
end


return Dict
