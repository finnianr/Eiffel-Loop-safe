note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of `STRING_32'
		field attribute types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-20 12:16:39 GMT (Sunday 20th May 2018)"
	revision: "3"

class
	EL_ESCAPED_STRING_32_FIELD_VALUE_TABLE

inherit
	HASH_TABLE [STRING_32, STRING]
		rename
			make as make_with_count
		redefine
			empty_duplicate
		end

	EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE [STRING_32]
		redefine
			escaper
		end

create
	make

feature {NONE} -- 19.05

	empty_duplicate (n: INTEGER): like Current
			-- Create an empty copy of Current that can accommodate `n' items
		do
			create Result.make (n, escaper)
			if object_comparison then
				Result.compare_objects
			end
		end

feature {NONE} -- Initialization

	make (n: INTEGER; a_escaper: like escaper)
		do
			make_table (n)
			escaper := a_escaper
		end

feature {NONE} -- Implementation

	escaped_value (str: STRING_32): STRING_32
		do
			Result := escaper.escaped (str, True)
		end

feature {NONE} -- Internal attributes

	escaper: EL_STRING_32_ESCAPER

end
