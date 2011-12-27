local string, table = string, table
local tinsert, tremove, concat, tsort = table.insert, table.remove, table.concat, table.sort


-- this is a LIST prototype, and all of list instances inherit it
local List = {}

--itself as  its metatable
List.__index = List
List.__typename = "List"

-- constructor of List object
local function new (tbl)
	-- if tbl is nil, then empty table returned
	local t = {}

	if tbl then
		assert(types(tbl, 'table'))
		--only List part are passed into/// call takeAparts() directly
		for i, v in ipairs(tbl) do
			t[i] = v
		end
	end

	-- setting the inheritance relationship
	return setmetatable(t, List)
end

-- binding constructor new(tbl) with List() sytanx
-- table can be accessed via __index from its/List metatable. It means List can reuse the table API??
setmetatable(List, {
	__call = function (self, tbl)
		return new(tbl)
	end,
	__index = table
})


local function interval_index (i, max)
	if i > max then return max end
	if i >= 1 then return i end
	if i >= 0 then return 1 end
	i = max +i
	if i >=1 then return i end
	return 1
end

-- the normalization of indice
local function normalize_slice( self, start, stop )
	local start = start or 1
	local stop = stop or #self

	if (stop > 0 and start > 0) or (stop < 0 and start < 0) then assert( stop >= start) end
	if start > #self then return nil, nil end

	-- the negative index
	-- -1 is the last elment, -2 the penultimate, and so on
	if start == 0 then
		start = 1
	elseif start < 0 then
		if math.abs(start) >= #self then
			start = 1
		else
			start = #self + start + 1
		end
	end
	if stop == 0 then
		stop = 1
	elseif stop < 0 then
		stop = #self + stop + 1
		if stop < 1 then return nil, nil end
	end

	return start, stop
end


------------------------------------------------------------------------
-- @class method
-- start para is optional, and the default value is 1
-- generate a sequence of integers
function List.range(start, finish)
	if not finish then
		finish = start
		start = 1
	end
	assert (types(start,'number', finish, 'number'))

	local  t = new()
	for i = start, finish do
		t[#t+1] = i
	end
	return t
end


function List.mapn (fn, ...)
	local res = List()
	local lists = {...}
	local nl = #lists
	if nl==0 then return res end

	local args = {}
	for i = 1, #(lists[1]) do
		for j = 1, nl do
			local a = lists[j][i]
			if nil == a then return res end
			args[j] = a
		end
		res[#res+1] = fn(unpack(args))
	end
	return res
end


-- @usage zip({10,20,30},{100,200,300}) is {{10,100},{20,200},{30,300}}
function List.zip(...)
	return List.mapn(function(...) return {...} end, ...)
end

------------------------------------------------------------------------
-- @object methods

-- appending extra element at the tail of list
function List:append(val)
	self[#self+1] = val
	return self
end

-- 前加元素
-- super slow, time complexity is O(N). IF implemented by lua-table, it will be much better
function List:prepend(val)
	tinsert(self, 1, val)
	return self
end

--list expansion by another one
function List:extend( another )
	assert (types (another, 'table'))
	local l = #self
	for i = 1, #another do
		self [i+l] = another[i]
	end
	return self
end

-- delete by index
function List:iremove (i)
	assert (types (i, 'number'))
	tremove(self, i)
	return self
end

-- delete by value, and all of them
-- maybe a better API is List:remove(x, numOfDeletion)
-- if numOfDeletion is negative integer,then counting from the last one in reversing order.
function List:remove(x)
	for i=1, #self do
		while self[i] == x do
			tremove(self,i)
		end
		if nil == self[i] then break end
	end
	return self
end

-- push a new element into list at right-hand side
List.push = List.append

-- pop a element from list at right-hand side
function List:pop()
	return tremove(self)
end

-- starting from idx index and trying to find the first element with value=val,
function List:find(val, idx)
	checkType(self, 'table')
	local idx = idx or 1
	if idx < 0 then idx = #self + idx + 1 end
	for i = idx, #self do
		if self[i] == val then return i end
	end
	return nil
end

-- contain element x or not
function List:contains(x)
	return self:find(x, 1) and true or false
end

-- counting the times that element x appears in a list
function List:count(x)
	local cnt=0
	for i=1, #self do
		if self[i] == x then cnt = cnt+1 end
	end
	return cnt
end

-- simple wrapper of table.concat() method
function List:join(sep)
	return concat(self, sep)
end

-- sorting, a simple wrapper of table.sort()
function List:sort(cmp)
	tsort(self, cmp)
	return self
end

-- reverse the order of list elements
function List:reverse()
	local t = self
	local n = #t
	local n2 = n/2
	for i = 1, n2 do
		local k = n - i + 1
		t[i], t[k] = t[k], t[i]
	end
	return self
end

-- slicing
-- start, stop maybe nil, negative integer, or other values
function List:slice(start, stop, is_rev)
	-- NOTICE: here, should not use checkType!
	-- because start, stop, is_rev are all probably nil.
	local nt = List()
	local start, stop = normalize_slice(self, start, stop)
	if not start or not stop then return List() end

	if is_rev ~= 'rev' then
		for i = start, (#self > stop and stop or #self) do
			table.insert(nt, self[i])
		end
	else
		for i = (#self > stop and stop or #self), start, -1 do
			table.insert(nt, self[i])
		end
	end

	return nt
end

-- delete all of list elements
function List:clear()
	for k,_ in pairs(self) do
		self[k] = nil
	end
	return self
end

-- length/size of list
function List:len()
	return #self
end

-- deleted by indexing interval
function List:chop(i1,i2)
	assert(types(i1,'number',i2,'number'))
	local mx = #self+1
	i1 = interval_index (i1, mx)
	i2 = interval_index (i2, mx)
	local shrink = i2+1 - i1
	if shrink > 0 then
		for i = i2+1, #self do
			self[i-shrink] = self[i]
		end
		for i = mx-shrink, mx do
			self[i] = nil
		end
	end
	return self
end

-- insert another *list* at the location *idx*
function List:splice(idx, list)
	assert(types(idx,'number',list,'table'))
	idx = interval_index (idx, #self+1)
	local growth = #list
	if growth > 0 then
		for i = #self, idx, -1 do
			self[i+growth] = self[i]
		end
		for i,v in ipairs(list) do
			self[i+idx-1] = v
		end
	end
	return self
end

-- assignment in the style of slicing
function List:sliceAssign(i1, i2, seq)
	local mx = #self+1
	i1 = interval_index (i1, mx)
	i2 = interval_index (i2, mx)
	local seql = #seq
	local g = seql - (i2-i1)	-- growth
	if g>0 then
		for i = #self, i2, -1 do
			self[i+g] = self[i]
		end
	else
		for i = i2, #self do
			self[i+g] = self[i]
		end
		for i = #self+g+1, #self+1 do
			self[i] = nil
		end
	end
	for i = 1,seql do
		self[i1+i-1] = seq[i]
	end
	return self
end

-- + can be used as linking/expanding sign, like lnew = l1 + l2
function List:__add(another)
	checkType(another, 'table')

	local ls = List(self)
	ls:extend(another)
	return ls
end

-- equality operator in the context of  list, like l2 == l1?
function List:__eq(L)
	if #self ~= #L then return false end
	for i = 1, #self do
		if self[i] ~= L[i] then return false end
	end
	return true
end


--function List:__tostring()
--     return '{' .. self:join(',') .. '}'
--end

--%%%%%%%%%%%%%%%%%%%
-- keep my eye on it
--%%%%%%%%%%%%%%%%%%%
-- perform the operation fn for each element of list, and a new list returned
function List:map(fn, ...)
	list = {...}
	res = {}
	for i = 1, #list do
		res[#res + 1] = fn(list[i])
	end
	return res
end

-- 对所有元素执行函数操作，在自身上改变
function List:transform (fn, ...)

	return self
end




--
function List:isEmpty ()
	if type(self) ~= 'table' then
		error('You use isEmpty(), but the parameter is not a list.', 2)
	end

	if #self == 0 then
		return true
	else
		return false
	end
end


return List
