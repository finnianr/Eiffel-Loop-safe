note
	description: "[
		A string with a mix of literal characters and characters represented as an escape sequence
		starting with character `escape_character'.
	]"
	history: "[
		This class used to inherit directly from {STRING}. It no longer does due
		to issues of illegal creation calls when ES 19.05 with Comformance Void
		Safety was brought aboard. The creation calls made in {STRING} generated
		errors (rightfully so) because one cannot create instances (objects) of
		deferred classes, such as this one.
		
		The solution in this case was to move the inheritance of {STRING} to the
		immediate effective descendant class, leaving just the specialized features
		in this class that did not access features of {STRING} or to make dummy
		access features as deferred placeholders. In this case, there were none.
		
		It is imporant to note that presently there is but a single effective descendant
		class to this one. Should there ever be a need for mor than one, this design
		will need to be revisited to revise how specialized features that were moved
		from here to the single descendant must be coded in light of inheritance.
		For now--there is little needing to be done to improve the code structure as-is.
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
			-- `adjusted_character' of `c'.
		note
			question: "What does this feature actually do?"
		do
			Result := c
		end

	is_sequence_digit (c: CHARACTER): BOOLEAN
			-- Is `c' a "hexadecimal sequence digit"?
		do
			Result := c.is_hexa_digit
		end

	is_unescaped_basic (c: CHARACTER_32): BOOLEAN
			-- Is `c' 0-9, A-Z, or a-z?
		do
			inspect c
				when '0' .. '9', 'A' .. 'Z', 'a' .. 'z' then
					Result := True

			else end
		end

	substring_utf_8 (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING
			-- Convert UTF-32 `s' to UTF-8
		do
			Result := UTF.utf_32_string_to_utf_8_string_8 (s.substring (start_index, end_index).to_string_32)
		end

feature {NONE} -- Deferred implementation

	escape_character: CHARACTER
			-- escape sequence start character
		deferred
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
			-- Is `c' "unescaped extra"?
		deferred
		end

	sequence_count: INTEGER
			-- count of escape sequence digits
		deferred
		end

feature {NONE} -- Constants

	Utf_8_sequence: EL_UTF_8_SEQUENCE
			-- UTF-8 character sequence.
		once
			create Result.make
		end

	Unencoded_character: CHARACTER
		-- The substitute character SUB
		-- A substitute character (SUB) is a control character that is used in the place of a character that is
		-- recognized to be invalid or in error or that cannot be represented on a given device.
		-- See https://en.wikipedia.org/wiki/Substitute_character
		note
			EIS: "substitute_character", "src=https://en.wikipedia.org/wiki/Substitute_character"
		once
			Result := '%/026/'
		end

end
