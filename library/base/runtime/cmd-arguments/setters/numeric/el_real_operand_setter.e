note
	description: "Sets a `REAL' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:35:23 GMT (Friday 25th January 2019)"
	revision: "5"

class
	EL_REAL_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [REAL]
		rename
			put_reference as put_real_32
		redefine
			is_convertible, put_real_32
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := string_value.is_real_32
		end

	put_real_32 (a_value: like value; i: INTEGER)
		do
			make_routine.operands.put_real_32 (a_value, i)
		end

	value (str: ZSTRING): REAL
		do
			Result := str.to_real_32
		end
end
