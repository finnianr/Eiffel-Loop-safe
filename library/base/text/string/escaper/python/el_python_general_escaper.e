note
	description: "Python general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "7"

deferred class
	EL_PYTHON_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		end

feature {NONE} -- Initialization

	make (quote_count: INTEGER)
		require
			single_or_double_quotes: quote_count = 1 or quote_count = 2
		do
			if quote_count = 1 then
				make_escaper (once "%T%N\'")
			else
				make_escaper (once "%T%N\%"")
			end
		end

end
