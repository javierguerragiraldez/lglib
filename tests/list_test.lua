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

	test ('pop', strict.wrap(function ()
		local l = List{'a','b','c'}
		assert_equal ('c', l:pop())
		assert_true (l:equal{'a','b'})

		assert_equal ('b', l:pop())
		assert_true (l:equal{'a'})

		assert_equal ('a', l:pop())
		assert_true (l:equal{})

		assert_equal (nil, l:pop())
		assert_true (l:equal{})
	end))

	test ('find', strict.wrap(function ()
		assert_equal (3, List{'a','b','c','d'}:find('c'))
		assert_equal (2, List{'a','b','c','b'}:find('b'))
		assert_equal (nil, List{'a','b','c','b'}:find('d'))
		assert_equal (nil, List{}:find('a'))
	end))

	test ('contains', strict.wrap(function ()
		assert_true (List{'a','b','c'}:contains('a'))
		assert_true (List{'a','b','c'}:contains('b'))
		assert_true (List{'a','b','c'}:contains('c'))
		assert_false (List{'a','b','c'}:contains('d'))
		assert_false (List{'a','b','c'}:contains(nil))
		assert_false (List{}:contains('a'))
	end))

	test ('count', strict.wrap(function ()
		assert_equal (0, List{}:count('a'))
		assert_equal (1, List{'a','b','c'}:count('a'))
		assert_equal (2, List{'a','b','a'}:count('a'))
	end))

	test ('join', strict.wrap(function ()
		assert_equal ('', List{}:join())
		assert_equal ('', List{}:join(','))
		assert_equal ('a', List{'a'}:join())
		assert_equal ('a', List{'a'}:join(','))
		assert_equal ('abc', List{'a','b','c'}:join())
		assert_equal ('a,b,c', List{'a','b','c'}:join(','))
	end))

	test ('sort', strict.wrap(function ()
		assert_true (List{'b','c','a'}:sort():equal{'a','b','c'})
		assert_true (List{'b','c','a'}:sort(function(a,b)return a>b end):equal{'c','b','a'})
	end))

	test ('reverse', strict.wrap(function ()
		assert_true (List{'a','b','c','d'}:reverse():equal{'d','c','b','a'})
		assert_true (List{'a','b','c'}:reverse():equal{'c','b','a'})
	end))

	test ('slice', strict.wrap(function ()
		assert_true (List{'a','b','c','d'}:slice(2,3):equal{'b','c'})
		assert_true (List{'a','b','c','d'}:slice(2,30):equal{'b','c','d'})
		assert_true (List{'a','b','c','d'}:slice(1,3):equal{'a','b','c'})
		assert_true (List{'a','b','c','d'}:slice(0,3):equal{'a','b','c'})
		assert_true (List{'a','b','c','d'}:slice(2,-1):equal{'b','c','d'})
		assert_true (List{'a','b','c','d'}:slice(-3,-2):equal{'b','c'})
	end))

	test ('clear', strict.wrap(function ()
		assert_true (List{}:clear():equal{})
		assert_true (List{'a'}:clear():equal{})
		assert_true (List{'a','b','c'}:clear():equal{})
	end))

	test ('len', strict.wrap(function ()
		assert_equal (0, List{}:len())
		assert_equal (1, List{'a'}:len())
		assert_equal (3, List{'a','b','c'}:len())
	end))

	test ('chop', strict.wrap(function ()
		assert_true (List{'a','b','c','d'}:chop(2,3):equal{'a','d'})
		assert_true (List{'a','b','c','d'}:chop(2,2):equal{'a','c','d'})
		assert_true (List{'a','b','c','d'}:chop(2,-2):equal{'a','d'})
		assert_true (List{'a','b','c','d'}:chop(-3,-2):equal{'a','d'})
		assert_true (List{'a','b','c','d'}:chop(1,-1):equal{})
	end))

	test ('splice', strict.wrap(function ()
		assert_true (List{'a','b','c'}:splice(2,{}):equal{'a','b','c'})
		assert_true (List{'a','b','c'}:splice(2,{'x','y','z'}):equal{'a','x','y','z','b','c'})
		assert_true (List{'a','b','c'}:splice(4,{'x','y','z'}):equal{'a','b','c','x','y','z'})
		assert_true (List{'a','b','c'}:splice(1,{'x','y','z'}):equal{'x','y','z','a','b','c'})
		assert_true (List{'a','b','c'}:splice(0,{'x','y','z'}):equal{'x','y','z','a','b','c'})
		assert_true (List{'a','b','c'}:splice(-1,{'x','y','z'}):equal{'a','b','c','x','y','z'})
	end))

	test ('sliceAssign', strict.wrap(function ()
		assert_true (List{}:sliceAssign(0,0,{}):equal{})
		assert_true (List{}:sliceAssign(0,0,{'a','b'}):equal{'a','b'})
		assert_true (List{'x'}:sliceAssign (0,0,{'a','b'}):equal{'a','b','x'})

		assert_true (List{'x','y','z'}:sliceAssign (0,0,{'a','b'}):equal{'a','b','x','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (1,1,{'a','b'}):equal{'a','b','x','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (2,2,{'a','b'}):equal{'x','a','b','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (3,3,{'a','b'}):equal{'x','y','a','b','z'})

		assert_true (List{'x','y','z'}:sliceAssign (0,1,{'a','b'}):equal{'a','b','x','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (1,2,{'a','b'}):equal{'a','b','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (2,2,{'a','b'}):equal{'x','a','b','y','z'})
		assert_true (List{'x','y','z'}:sliceAssign (3,3,{'a','b'}):equal{'x','y','a','b','z'})
	end))
end)
