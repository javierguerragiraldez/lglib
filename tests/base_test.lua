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
		end))

	end)

end)
