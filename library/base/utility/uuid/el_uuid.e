note
	description: "Uuid"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "11"

class
	EL_UUID

inherit
	UUID
		rename
			make_from_string as make_from_string_general
		undefine
			is_equal
		redefine
			make,
			make_from_string_general,
			make_from_array
		select
			debug_output
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		undefine
			out
		redefine
			adjust_field_order
		end

	EL_MAKEABLE_FROM_STRING_8
		rename
			make as make_from_string
		undefine
			out, is_equal
		end

create
	make_default, make, make_from_string_general, make_from_string, make_from_array

feature {NONE} -- Implementation

	make (d1: NATURAL_32; d2, d3, d4: NATURAL_16; d5: NATURAL_64)
			--<Precursor>
		do
			create field_table.make (5)
			Precursor (d1, d2, d3, d4, d5)
		end

	make_from_string_general (a_uuid: READABLE_STRING_GENERAL)
			--<Precursor>
		do
			create field_table.make (5)
			Precursor (a_uuid)
		end

	make_from_array (a_segs: ARRAY [NATURAL_8])
			--<Precursor>
		do
			create field_table.make (5)
			Precursor (a_segs)
		end

	make_from_string (str: STRING)
		do
			create field_table.make (5)
			make_from_string_general (str)
		end

	adjust_field_order (fields: EL_REFLECTED_FIELD_ARRAY)
		-- change order to: data_1, data_2 etc
		do
			fields.reorder (<<
				[4, -3] -- `date_1' left 3
			>>)
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	field_hash: NATURAL = 201719989

end
