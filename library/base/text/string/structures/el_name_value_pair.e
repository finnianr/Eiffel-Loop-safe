note
	description: "Parses string for name value pair using specified delimiter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 14:23:22 GMT (Monday 17th December 2018)"
	revision: "5"

class
	EL_NAME_VALUE_PAIR [G -> STRING_GENERAL create make, make_empty end]

create
	make, make_empty, make_pair

feature {NONE} -- Initialization

	make (str: G; delimiter: CHARACTER_32)
		do
			set_from_string (str, delimiter)
			if not attached name then
				make_empty
			end
		end

	make_empty
		do
			create name.make_empty; create value.make_empty
		end

	make_pair (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
		end

feature -- Element change

	set_from_string (str: G; delimiter: CHARACTER_32)
		local
			pos_colon: INTEGER
		do
			pos_colon := str.index_of (delimiter, 1)
			if pos_colon > 0 then
				name := str.substring (1, pos_colon - 1)
				value := str.substring (pos_colon + 1, str.count)
				value.left_adjust; value.right_adjust
			end
		end

feature -- Access

	name: G
		attribute
			create Result.make_empty
		end

	value: G

	as_assignment: G
		do
			Result := joined ('=')
		end

	joined (separator: CHARACTER): G
		do
			create Result.make (name.count + value.count + 1)
			Result.append (name)
			Result.append_code (separator.natural_32_code)
			Result.append (value)
		end
end
