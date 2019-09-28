note
	description: "Xpath parts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:51:27 GMT (Monday 5th August 2019)"
	revision: "6"

class
	EL_XPATH_PARTS

inherit
	ANY
		redefine
			default_create
		end

	EL_STRING_32_CONSTANTS

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			attribute_name := Empty_string_32
			xpath := Empty_string_32
		end

feature -- Access

	attribute_name: READABLE_STRING_GENERAL

	xpath: READABLE_STRING_GENERAL

feature -- Element change

	set_from_xpath (a_xpath: READABLE_STRING_GENERAL)
		local
			pos_at_symbol: INTEGER
		do
			pos_at_symbol := a_xpath.last_index_of ('@', a_xpath.count)
			inspect pos_at_symbol
				when 0 then
					xpath := a_xpath
					attribute_name := Empty_string_32
				when 1 then
					xpath := Empty_string_32
					attribute_name := a_xpath.substring (2, a_xpath.count)

			else
				xpath := a_xpath.substring (1, pos_at_symbol - 1)
				attribute_name := a_xpath.substring (pos_at_symbol + 1, a_xpath.count)
			end
		end

end
