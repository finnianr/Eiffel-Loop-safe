note
	description: "String 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-11 12:15:48 GMT (Friday 11th January 2019)"
	revision: "7"

class
	EL_STRING_32_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_32]

feature -- Conversion

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

feature -- Measurement

	latin_1_count (s: STRING_32): INTEGER
		-- count of latin-1 characters
		local
			i, count: INTEGER; area: SPECIAL [CHARACTER_32]
		do
			area := s.area; count := s.count
			from i := 0 until i = count loop
				if area.item (i).natural_32_code <= 0xFF then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Transformation

	left_adjust (str: STRING_32)
		do
			str.left_adjust
		end

	prune_all_leading (str: STRING_32; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: STRING_32)
		do
			str.right_adjust
		end

end
