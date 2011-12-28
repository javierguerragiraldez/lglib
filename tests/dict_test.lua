-- require 'lglib'
--
-- Dict = require 'lglib.dict'
--
-- a = Dict {
-- 	x = 'xxxxxx',
-- 	y = '34343434',
-- 	z = 'zcvcvc',
-- 	g = '4444444',
-- 	h = '34343aaa',
--
-- }
--
-- ptable(a:keys())
-- ptable(a:values())
-- print(a:hasKey('x'))
-- print(a:hasKey('xx'))
-- print(a:isEmpty())
--
--
local strict = require 'lglib.strict'
require 'lglib'
Dict = require 'lglib.dict'
strict.off()

local function cmp(a,b)
	local ta,tb = type(a),type(b)
	return ta==tb and a<b or ta<tb
end


context ('Dict', function ()

	test ('new', strict.wrap(function ()
		local t = Dict()
		assert_true (types(t,'table'))
		local a = Dict { 1,2,3,4,5,6,7, [156]='wayout', x=123, y="343434"}
		assert_true (table.equal({x=123,y="343434",[156]='wayout'}, a))
		assert_nil (a[1])
		assert_nil (a[5])
		assert_equal (table.insert, a.insert)
	end))

	test ('keys', strict.wrap(function ()
		assert_true(Dict{x=123,y="4353",[54]=33,["long key"]=false}:keys():sort(cmp):equal{54,'long key','x','y'})
	end))

	test ('hasKey', strict.wrap(function ()
		local d = Dict{x=123,y='abc',[65]='xyz'}
		assert_true (d:hasKey('x'))
		assert_true (d:hasKey('y'))
		assert_true (d:hasKey(65))
		assert_false(d:hasKey(1))
		d[1]='w'
		assert_false(d:hasKey(1))
		assert_equal('w',d[1])
	end))

	test ('size', strict.wrap(function ()
		local d = Dict{x=123,y='abc',[65]='xyz'}
		assert_equal (3, d:size())
		d[1]='w'
		assert_equal (3, d:size())
		assert_equal('w',d[1])
	end))

	test ('values', strict.wrap(function ()
		assert_true(Dict{x=123,y="4353",[54]=33,["long key"]=false}:values():sort(cmp):equal{false,33,123,"4353"})
	end))

end)