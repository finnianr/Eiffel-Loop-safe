note
	description: "Sorted set of field indices for reflected object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-02 9:41:17 GMT (Sunday 2nd June 2019)"
	revision: "3"

class
	EL_FIELD_INDICES_SET

inherit
	ARRAY [INTEGER]
		rename
			make as make_count
		end

create
	make

feature {NONE} -- Initialization

	make (reflected: REFLECTED_REFERENCE_OBJECT; field_names: STRING)
		local
			field_list: EL_SPLIT_STRING_LIST [STRING]; i, j: INTEGER
		do
			if field_names.is_empty then
				make_empty
			else
				create field_list.make (field_names, once ",")
				field_list.left_adjusted.enable

				make_filled (0, 1, field_list.count)
				from i := 1 until i > reflected.field_count loop
					if field_list.has (reflected.field_name (i)) then
						j := j + 1
						put (i, j)
					end
					i := i + 1
				end
			end
		ensure
			all_fields_found: not has (0)
		end

end
