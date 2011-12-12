local strict = require 'lglib.strict'
require 'lglib'
List = require 'lglib.list'
strict.off()


context ('list', function ()
	test ('new', strict.wrap(function ()
		local t = List()
		assert_true (types(t,'table'))
		local a = List { 1,2,3,4,5,6,7, x=123, y="343434"}
		assert_true (table.equal({1,2,3,4,5,6,7}, a))
		assert_nil (a.x)
		assert_nil (a.y)
		assert_equal (table.insert, a.insert)
	end))

	test ('range', strict.wrap(function ()
		assert_true(table.equal({1,2,3,4,5,6,7,8,9,10},List.range(10)))
		assert_true(table.equal({10,11,12,13,14,15,16,17,18,19,20},List.range(10, 20)))
	end))
	
end)
