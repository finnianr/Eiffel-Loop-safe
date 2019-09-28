note
	description: "Timed procedure main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_TIMED_PROCEDURE_MAIN_THREAD [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TIMED_PROCEDURE [BASE_TYPE, OPEN_ARGS]
		undefine
			stop_consumer
		redefine
			make_default
		end

	EL_COUNT_CONSUMER_MAIN_THREAD
		rename
			stop as stop_consumer,
			launch as launch_consumer
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_COUNT_CONSUMER_MAIN_THREAD}
			Precursor {EL_TIMED_PROCEDURE}
		end
end