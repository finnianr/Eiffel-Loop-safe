note
	description: "Reflected collection type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 14:42:06 GMT (Tuesday 11th June 2019)"
	revision: "1"

class
	EL_REFLECTED_COLLECTION_TYPE_TABLE [G]

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_COLLECTION [G], COLLECTION [G]]
		rename
			make as make_with_tuples
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

create
	make, make_size

feature {NONE} -- Initialization

	make (array: ARRAY [TYPE [EL_COLLECTION_TYPE_ASSOCIATION [G]]])
		do
			make_size (array.count)
			across array as type loop
				if attached {EL_COLLECTION_TYPE_ASSOCIATION [G]} new_instance_of (type.item.type_id) as collection_type then
					collection_type.make
					extend (collection_type.reflected_field_type, collection_type.type_id)
				end
			end
			initialize
		end

end
