note
	description: "White space z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_WHITE_SPACE_Z_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZCODEC

	EL_ZCODE_CONVERSION

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			if z_code <= 0xFF then
				Result := z_code.to_character_8.is_space
			else
				Result := z_code_to_unicode (z_code).to_character_32.is_space
			end
		end
end
