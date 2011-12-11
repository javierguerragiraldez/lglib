local strict = require 'lglib.strict'
require 'lglib'
strict.off()


context('lglib', function ()
	context('base', function ()
		test ('typename', strict.wrap(function ()
			assert_equal ('List', typename(List))
		end))

		test ('isXX', strict.wrap(function ()
			assert_true (isList(List))
			assert_true (isDict(Dict))
			assert_true (isSet(Set))
			assert_false (isList(Dict))
			assert_false (isDict(Set))
			assert_false (isSet(List))
		end))

		test ('checkType', strict.wrap(function ()
			assert_true (checkType (true, 1, 'a', {2},
					'boolean', 'number', 'string', 'table'))
			assert_error (function() checkType (1, 'string') end)
			assert_error (function() checkType (1, 2) end)
		end))

		test ('types', strict.wrap(function ()
			assert_true (types (1,'number'))
			assert_false(types (1, 'string'))
			assert_true (types (
				1, 'number',
				'a', 'string',
				true, 'boolean',
				nil, 'nil',
				{1}, 'table'))
			assert_false (types (
				1, 'number',
				'a', 'string',
				true, 'boolean',
				false, 'nil',
				{1}, 'table'))
		end))

		test ('ranges', strict.wrap(function ()
			assert_true  (ranges(5,2,6))
			assert_false (ranges(4,5,6))
			assert_false (ranges(5,2,4))

			assert_true  (ranges(5,2,6, 4,2,5))
			assert_false (ranges(5,2,6, 3,4,5))
			assert_false (ranges(5,2,6, 4,2,3))
			
			assert_true  (ranges(5,2,6, 4,2,5))
			assert_false (ranges(4,5,6, 4,2,5))
			assert_false (ranges(5,2,4, 4,2,5))
		end))

		test ('setProto', strict.wrap(function ()
			assert_error (function() setProto(1, 2) end)
			assert_error (function() setProto({}, 'a') end)
			local obj = setProto ({}, {a=5})
			assert_true (types (obj, 'table'))
			assert_equal (5, obj.a)
			local o2 = setProto (obj, {b=10})
			assert_equal (o2, obj)
			assert_equal (5, obj.a)
			assert_equal (10, obj.b)
			setProto (obj, {c=15, b='x'})
			assert_equal (5, obj.a)
			assert_equal (10, obj.b)
			assert_equal (15, obj.c)
		end))

	end)

end)
