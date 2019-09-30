note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of [$source EL_ZSTRING]
		field attribute types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 13:50:06 GMT (Tuesday 10th April 2018)"
	revision: "3"

class
	EL_ESCAPED_ZSTRING_FIELD_VALUE_TABLE

inherit
	HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_with_count
		redefine
			empty_duplicate
		end

	EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE [ZSTRING]
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

	escaped_value (str: ZSTRING): ZSTRING
		do
			Result := escaper.escaped (str, True)
		end

feature {NONE} -- Internal attributes

	escaper: EL_ZSTRING_ESCAPER

end
