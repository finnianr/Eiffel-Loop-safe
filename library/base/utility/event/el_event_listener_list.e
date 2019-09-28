note
	description: "[
		Object for managing a list of event listeners. It can all be used to make a one-many event
		listener, as the list itself conforms to [$source EL_EVENT_LISTENER].
		
		Due to limitations of Eiffel ARRAY manifest conformance checking, the automatic conversion
		is not useable as intended with compiler version 16.05, but perhaps in a future version
		it will be useable.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:00:09 GMT (Wednesday 21st February 2018)"
	revision: "2"

class
	EL_EVENT_LISTENER_LIST

inherit
	ARRAYED_LIST [EL_EVENT_LISTENER]
		rename
			make_from_array as make,
			make as make_with_count
		end

	EL_EVENT_LISTENER
		rename
			notify as notify_all
		undefine
			copy, is_equal
		end

create
	make

convert
	make ({ARRAY [EL_EVENT_LISTENER]})

feature -- Basic operations

	notify_all
		do
			from start until after loop
				item.notify
				forth
			end
		end
end
