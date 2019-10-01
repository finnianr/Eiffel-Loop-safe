note
	description: "UTF-8 sequence for single unicode character `uc'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-10 19:07:24 GMT (Thursday 10th January 2019)"
	revision: "3"

class
	EL_UTF_8_SEQUENCE

inherit
	EL_UTF_SEQUENCE
		rename
			default_create as default_create_utf_sequence
		end

	STRING_HANDLER
		select
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled_area (0, 4)
		end

feature -- Element change

	set (uc: CHARACTER_32)
		local
			code: NATURAL; l_area: like area
		do
			l_area := area
			code := uc.natural_32_code
			if code <= 0x7F then
					-- 0xxxxxxx
				area [0] := code
				count := 1

			elseif code <= 0x7FF then
					-- 110xxxxx 10xxxxxx
				area [0] := (code |>> 6) | 0xC0
				area [1] := (code & 0x3F) | 0x80
				count := 2

			elseif code <= 0xFFFF then
					-- 1110xxxx 10xxxxxx 10xxxxxx
				area [0] := (code |>> 12) | 0xE0
				area [1] := ((code |>> 6) & 0x3F) | 0x80
				area [2] := (code & 0x3F) | 0x80
				count := 3
			else
					-- code <= 1FFFFF - there are no higher code points
					-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				area [0] := (code |>> 18) | 0xF0
				area [1] := ((code |>> 12) & 0x3F) | 0x80
				area [2] := ((code |>> 6) & 0x3F) | 0x80
				area [3] := (code & 0x3F) | 0x80
				count := 4
			end
		end

feature -- Measurement

	byte_count (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= str.count
			valid_bounds: start_index <= end_index + 1
		local
			i: INTEGER; code: NATURAL
		do
			from i := start_index until i > end_index loop
				code := str.item (i).natural_32_code
				if code <= 0x7F then
						-- 0xxxxxxx
					Result := Result + 1

				elseif code <= 0x7FF then
						-- 110xxxxx 10xxxxxx
					Result := Result + 2

				elseif code <= 0xFFFF then
						-- 1110xxxx 10xxxxxx 10xxxxxx
					Result := Result + 3
				else
						-- code <= 1FFFFF - there are no higher code points
						-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
					Result := Result + 4
				end
				i := i + 1
			end
		end

feature -- Conversion

	to_hexadecimal_escaped (escape_character: CHARACTER): STRING
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL; buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count * 3)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				code := l_area [i]
				buffer_area [i * 3] := escape_character
				buffer_area [i * 3 + 1] := (code |>> 4).to_hex_character
				buffer_area [i * 3 + 2] := (code & 0xF).to_hex_character
				i := i + 1
			end
			Result.set_count (l_count * 3)
		end

	to_octal_escaped (escape_character: CHARACTER): STRING
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL; buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count * 4)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				code := l_area [i]
				buffer_area [i * 4] := escape_character
				buffer_area [i * 4 + 1] := octal_character (code |>> 6)
				buffer_area [i * 4 + 2] := octal_character ((code |>> 3) & 0x7)
				buffer_area [i * 4 + 3] := octal_character (code & 0x7)
				i := i + 1
			end
			Result.set_count (l_count * 3)
		end

	to_utf_8: STRING
		local
			i, l_count: INTEGER; l_area: like area
			buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				buffer_area [i] := l_area.item (i).to_character_8
				i := i + 1
			end
			Result.set_count (l_count * 3)
		end

feature -- Basic operations

	write (writeable: EL_WRITEABLE)
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_raw_character_8 (l_area.item (i).to_character_8)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	octal_character (n: NATURAL): CHARACTER_8
			-- Convert `n' to its corresponding character representation.
		do
			Result := (Zero_code + n).to_character_8
		end

feature {NONE} -- Constants

	Buffer: STRING = ""

	Zero_code: NATURAL = 48

end
