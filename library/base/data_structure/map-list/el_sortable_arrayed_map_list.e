note
	description: "Arrayed list of key-value pair tuples that can be sorted"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 8:43:06 GMT (Saturday 19th May 2018)"
	revision: "1"

deferred class
	EL_SORTABLE_ARRAYED_MAP_LIST [K -> HASHABLE, G]

inherit
--	EL_ARRAYED_MAP_LIST [K, G]

	PART_COMPARATOR [TUPLE [K, G]]
		undefine
			is_equal, copy
		end

feature -- Basic operations

	sort (in_ascending_order: BOOLEAN)
			-- `sort' Current `in_ascending_order'
		deferred
		end

end
