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

	test ('append', strict.wrap(function ()
		assert_true (List{1,2,3}:append(4):equal{1,2,3,4})
		assert_true (List{1,2,3}:append('x'):equal{1,2,3,'x'})
		assert_true (List{1,2,3}:append(nil):equal{1,2,3})
	end))

	test ('prepend', strict.wrap(function ()
		assert_true (List{1,2,3}:prepend(4):equal{4,1,2,3})
		assert_true (List{1,2,3}:prepend('x'):equal{'x',1,2,3})
		assert_true (List{1,2,3}:prepend(nil):equal{nil,1,2,3})
	end))

	test ('extend', strict.wrap(function ()
		assert_true (List{1,2,3}:extend{}:equal{1,2,3})
		assert_true (List{1,2,3}:extend{4}:equal{1,2,3,4})
		assert_true (List{1,2,3}:extend{4,5,6}:equal{1,2,3,4,5,6})
		assert_error (function () List{1,2,3}:extend(nil) end)
	end))

	test ('iremove', strict.wrap(function ()
		assert_true (List{'a','b','c'}:iremove(0):equal{'a','b','c'})
		assert_true (List{'a','b','c'}:iremove(1):equal{    'b','c'})
		assert_true (List{'a','b','c'}:iremove(2):equal{'a',    'c'})
		assert_true (List{'a','b','c'}:iremove(3):equal{'a','b'    })
		assert_true (List{'a','b','c'}:iremove(4):equal{'a','b','c'})
	end))

	test ('remove', strict.wrap(function ()
		assert_true (List{'a','b','c'}:remove('a'):equal{    'b','c'})
		assert_true (List{'a','b','c'}:remove('b'):equal{'a',    'c'})
		assert_true (List{'a','b','c'}:remove('c'):equal{'a','b'    })
		assert_true (List{'a','b','c'}:remove('d'):equal{'a','b','c'})
		assert_true (List{'a','b','a','c'}:remove('a'):equal{'b','c'})

		assert_true (List{'a','b','b','c'}:remove('b'):equal{'a','c'})
	end))
end)
