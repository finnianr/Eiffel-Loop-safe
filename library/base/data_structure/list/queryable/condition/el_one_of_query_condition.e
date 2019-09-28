note
	description: "One of query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 11:58:02 GMT (Sunday 4th November 2018)"
	revision: "6"

class
	EL_ONE_OF_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_conditions: like conditions)
		do
			conditions := a_conditions
		end

feature -- Access

	met (item: G): BOOLEAN
		-- True if `item' meets at least one of the `conditions'
		do
			Result := across conditions as condition some
				condition.item.met (item)
			end
		end

feature {NONE} -- Implementation

	conditions: ARRAY [EL_QUERY_CONDITION [G]]

end
