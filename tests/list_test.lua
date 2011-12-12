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

	test ('mapn', strict.wrap(function ()
		local n=0
		local t=List()
		local function rec (...)
			t[#t+1] = {...}
			n = n+1
			return n
		end
		local t2 = List.mapn(rec, {'a','b','c'})
		assert_equal ('{{"a"},{"b"},{"c"}}', serialize(t))
		assert_equal ('{1,2,3}', serialize(t2))

		n=0
		t=List()
		t2 = List.mapn(rec, {'a','b','c'},{'x','y','z'})
		assert_equal ('{{"a","x"},{"b","y"},{"c","z"}}', serialize(t))
		assert_equal ('{1,2,3}', serialize(t2))

		n=0
		t=List()
		t2 = List.mapn(rec, {'a','b','c'},{'x','y'})
		assert_equal ('{{"a","x"},{"b","y"}}', serialize(t))
		assert_equal ('{1,2}', serialize(t2))
	end))

	test ('zip', strict.wrap(function ()
		assert_equal (
			'{{"a","x"},{"b","y"},{"c","z"}}',
			serialize(List.zip({'a','b','c'},{'x','y','z'})))
		assert_equal (
			'{{"a","x"},{"b","y"}}',
			serialize(List.zip({'a','b','c'},{'x','y'})))
	end))
	
end)
