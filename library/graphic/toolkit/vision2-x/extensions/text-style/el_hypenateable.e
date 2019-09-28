note
	description: "Hypenateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 12:03:30 GMT (Friday 21st December 2018)"
	revision: "6"

class
	EL_HYPENATEABLE

feature -- Status query

	is_hyphenated: BOOLEAN
		-- true if words are split across lines by hyphens

feature -- Status setting

	enable_word_hyphenation
		-- enable splitting of words across lines
		do
			is_hyphenated := True
		end

	disable_word_hyphenation
		-- disable text hyphenation
		do
			is_hyphenated := False
		end

end