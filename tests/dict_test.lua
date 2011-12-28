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

end)