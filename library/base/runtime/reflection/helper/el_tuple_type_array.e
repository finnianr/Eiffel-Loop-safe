note
	description: "Array of TUPLE parameter types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:12:50 GMT (Monday 1st July 2019)"
	revision: "3"

class
	EL_TUPLE_TYPE_ARRAY

inherit
	ARRAY [TYPE [ANY]]
		rename
			make as make_array
		end

	EL_REFLECTOR_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_EIFFEL

create
	make, make_from_static, make_from_tuple

feature {NONE} -- Initialization

	make (type: TYPE [TUPLE])
		local
			i: INTEGER
		do
			make_filled ({INTEGER}, 1, type.generic_parameter_count)
			from i := 1 until i > count loop
				put (type.generic_parameter_type (i), i)
				i := i + 1
			end
		end

	make_from_static (static_type: INTEGER)
		do
			if attached {TYPE [TUPLE]} Eiffel.type_of_type (static_type) as type then
				make (type)
			else
				make_filled ({INTEGER}, 0, 0)
			end
		end

	make_from_tuple (tuple: TUPLE)
		do
			make_from_static (Eiffel.dynamic_type (tuple))
		end

feature -- Status query

	is_latin_1_representable: BOOLEAN
		do
			Result := for_all (agent type_is_latin_1_representable)
		end

feature {NONE} -- Implementation

	type_is_latin_1_representable (type: TYPE [ANY]): BOOLEAN
		do
			if String_collection_type_table.has_conforming (type.type_id) then
				Result := type.type_id = String_8_type
			else
				Result := True
			end
		end
end
