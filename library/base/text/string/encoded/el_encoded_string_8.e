note
	description: "[
		A string with a mix of literal characters and characters represented as an escape sequence
		starting with character `escape_character'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:02:48 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_ENCODED_STRING_8

inherit
	EL_MODULE_UTF

	EL_MODULE_HEXADECIMAL

feature {NONE} -- Implementation

	adjusted_character (c: CHARACTER): CHARACTER
		do
			Result := c
		end

	is_sequence_digit (c: CHARACTER): BOOLEAN
		do
			Result := c.is_hexa_digit
		end

	is_unescaped_basic (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'Z', 'a' .. 'z' then
					Result := True

			else end
		end

	substring_utf_8 (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING
		do
			Result := UTF.utf_32_string_to_utf_8_string_8 (s.substring (start_index, end_index).to_string_32)
		end

feature {NONE} -- Deferred implementation

	escape_character: CHARACTER
		-- escape sequence start character
		deferred
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		deferred
		end

	sequence_count: INTEGER
		-- count of escape sequence digits
		deferred
		end

feature {NONE} -- Constants

	Utf_8_sequence: EL_UTF_8_SEQUENCE
		once
			create Result.make
		end

	Unencoded_character: CHARACTER = '%/026/'
		-- The substitute character SUB
		-- A substitute character (SUB) is a control character that is used in the place of a character that is
		-- recognized to be invalid or in error or that cannot be represented on a given device.
		-- See https://en.wikipedia.org/wiki/Substitute_character
end
