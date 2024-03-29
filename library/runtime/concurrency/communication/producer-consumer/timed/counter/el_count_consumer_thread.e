note
	description: "Count consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_COUNT_CONSUMER_THREAD

inherit
	EL_COUNT_CONSUMER
		undefine
			default_create, is_equal, copy, stop, name
		redefine
			make_default
		end

	EL_CONSUMER_THREAD [INTEGER]
		rename
			consume_product as consume_count,
			product as count
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_COUNT_CONSUMER}
			Precursor {EL_CONSUMER_THREAD}
		end

end