note
	description: "List of tuple element types conforming to generic type `T'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-14 11:28:59 GMT (Saturday   14th   September   2019)"
	revision: "2"

class
	EL_TUPLE_TYPE_LIST [T]

inherit
	EL_ARRAYED_LIST [TYPE [T]]
		rename
			make as make_list,
			make_from_tuple as make_list_from_tuple
		end

create
	make, make_from_static, make_from_tuple, make_list

feature {NONE} -- Initialization

	make (type_array: EL_TUPLE_TYPE_ARRAY)
		do
			make_list (type_array.count)
			across type_array as type loop
				-- skip non-conforming types
				if attached {like item} type.item as l_type then
					extend (l_type)
				end
			end
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (create {EL_TUPLE_TYPE_ARRAY}.make_from_tuple (tuple))
		end

	make_from_static (static_type: INTEGER)
		do
			make (create {EL_TUPLE_TYPE_ARRAY}.make_from_static (static_type))
		end

end
