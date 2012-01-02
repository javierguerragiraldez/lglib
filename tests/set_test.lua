-- require 'lglib'
--
-- Set = require 'lglib.set'
--
-- s1 = Set { 'a', 'b', 'c', 'd', 'e', 'f' }
-- s2 = Set { 'a', 'g', 'h', '0oo', 'e', 'f' }
-- s3 = Set { 'a', 'c', 'd'}
--
-- ptable(s1)
--
-- ptable(s1+s2)
-- ptable(s1-s2)
-- ptable(s1*s2)
-- ptable(s1^s2)
-- print(s3 < s1)
-- print(s2 < s1)
--
-- print(s1)
-- s2:add('123')
-- s2:add('456')
-- ptable(s2)


local strict = require 'lglib.strict'
require 'lglib'
Set = require 'lglib.set'
strict.off()

local function cmp(a,b)
	local ta,tb = type(a),type(b)
	return ta==tb and a<b or ta<tb
end

context ('Set', function ()

	test ('new', strict.wrap(function ()
		local s = Set{}
		assert_equal ("Set", typename(s))
		s = Set{'a',4,'x'}
		assert_true (s:has('a'))
		assert_false (s:has('b'))
		assert_true (s:has(4))
		assert_false (s:has('4'))
		assert_true (s:has('x'))
	end))

	test ('add', strict.wrap(function ()
		local s = Set{'a','c'}
		assert_false (s:has('b'))
		s:add('b')
		assert_true (s:has('b'))
	end))

	test ('delete', strict.wrap(function ()
		local s = Set{'a','b'}
		assert_true (s:has('a'))
		assert_true (s:has('b'))
		s:delete('b')
		assert_true (s:has('a'))
		assert_false (s:has('b'))
	end))

	test ('members', strict.wrap(function ()
		assert_true (Set{}:members():equal{})
		assert_true (Set{'a',4,'x'}:members():sort(cmp):equal{4,'a','x'})
		assert_true (Set{'a',4,'a','x'}:members():sort(cmp):equal{4,'a','x'})
	end))

	test ('union', strict.wrap(function ()
		assert_true (Set{}:union(Set{}):members():equal{})
		assert_true (Set{'a','c'}:union(Set{'b',4}):members():sort(cmp):equal{4,'a','b','c'})
		assert_true (Set{}:union(Set{'b',4}):members():sort(cmp):equal{4,'b'})
		assert_true (Set{'a','c'}:union(Set{}):members():sort(cmp):equal{'a','c'})

		assert_true ((Set{} + Set{}):members():equal{})
		assert_true ((Set{'a','c'} + Set{'b',4}):members():sort(cmp):equal{4,'a','b','c'})
		assert_true ((Set{} + Set{'b',4}):members():sort(cmp):equal{4,'b'})
		assert_true ((Set{'a','c'} + Set{}):members():sort(cmp):equal{'a','c'})
	end))

	test ('intersection', strict.wrap(function ()
		assert_true (Set{}:intersection(Set{}):members():equal{})
		assert_true (Set{}:intersection(Set{'b','c'}):members():equal{})
		assert_true (Set{'a','b'}:intersection(Set{}):members():equal{})
		assert_true (Set{'a','b'}:intersection(Set{'x','y'}):members():equal{})
		assert_true (Set{'a','b'}:intersection(Set{'b','c'}):members():equal{'b'})

		assert_true ((Set{} * Set{}):members():equal{})
		assert_true ((Set{} * Set{'b','c'}):members():equal{})
		assert_true ((Set{'a','b'} * Set{}):members():equal{})
		assert_true ((Set{'a','b'} * Set{'x','y'}):members():equal{})
		assert_true ((Set{'a','b'} * Set{'b','c'}):members():equal{'b'})
	end))

	test ('difference', strict.wrap(function ()
		assert_true (Set{}:difference(Set{}):members():equal{})
		assert_true (Set{}:difference(Set{'b','c'}):members():equal{})
		assert_true (Set{'a','b'}:difference(Set{}):members():equal{'a','b'})
		assert_true (Set{'a','b'}:difference(Set{'x','y'}):members():equal{'a','b'})
		assert_true (Set{'a','b'}:difference(Set{'b','c'}):members():equal{'a'})

		assert_true ((Set{} - Set{}):members():equal{})
		assert_true ((Set{} - Set{'b','c'}):members():equal{})
		assert_true ((Set{'a','b'} - Set{}):members():equal{'a','b'})
		assert_true ((Set{'a','b'} - Set{'x','y'}):members():equal{'a','b'})
		assert_true ((Set{'a','b'} - Set{'b','c'}):members():equal{'a'})
	end))

	test ('symmetricDifference', strict.wrap(function ()
		assert_true (Set{}:symmetricDifference(Set{}):members():equal{})
		assert_true (Set{'a','b'}:symmetricDifference(Set{}):members():sort(cmp):equal{'a','b'})
		assert_true (Set{}:symmetricDifference(Set{'a','b'}):members():sort(cmp):equal{'a','b'})
		assert_true (Set{'a','b'}:symmetricDifference(Set{'a','b'}):members():equal{})
		assert_true (Set{'a','b'}:symmetricDifference(Set{'x','y'}):members():sort(cmp):equal{'a','b','x','y'})
		assert_true (Set{'a','b'}:symmetricDifference(Set{'b','c'}):members():sort(cmp):equal{'a','c'})

		assert_true ((Set{} ^ Set{}):members():equal{})
		assert_true ((Set{'a','b'} ^ Set{}):members():sort(cmp):equal{'a','b'})
		assert_true ((Set{} ^ Set{'a','b'}):members():sort(cmp):equal{'a','b'})
		assert_true ((Set{'a','b'} ^ Set{'a','b'}):members():equal{})
		assert_true ((Set{'a','b'} ^ Set{'x','y'}):members():sort(cmp):equal{'a','b','x','y'})
		assert_true ((Set{'a','b'} ^ Set{'b','c'}):members():sort(cmp):equal{'a','c'})
	end))

	test ('isSub', strict.wrap(function ()
		assert_true (Set{}:isSub(Set{}))
		assert_true (Set{}:isSub(Set{'a','b'}))
		assert_false (Set{'a'}:isSub(Set{}))
		assert_false (Set{'a'}:isSub(Set{'b'}))
		assert_false (Set{'a','b'}:isSub(Set{'b'}))
		assert_true (Set{'a','b'}:isSub(Set{'a','b'}))
		local flg, elm = Set{'a','b'}:isSub(Set{'a'})
		assert_false (flg)
		assert_equal ('b', elm)

		assert_true (Set{} < Set{})
		assert_true (Set{} < Set{'a','b'})
		assert_false (Set{'a'} < Set{})
		assert_false (Set{'a'} < Set{'b'})
		assert_false (Set{'a','b'} < Set{'b'})
		assert_true (Set{'a','b'} < Set{'a','b'})
	end))

	test ('tostring', strict.wrap(function ()
		assert_equal (tostring(Set{}), '[]')
		assert_equal (tostring(Set{'a'}), '[a]')
		assert_equal (tostring(Set{4}), '[4]')
		assert_equal (tostring(Set{'a',4}), '[a,4]')
		assert_equal (tostring(Set{'x','y','z'}), '[y,x,z]')
	end))

end)
