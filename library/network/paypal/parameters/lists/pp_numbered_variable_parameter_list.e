note
	description: "[
		Parameter list with numbered variable names as for example:
		
			L_OPTION0PRICE1
			L_OPTION0PRICE2

			L_OPTION1PRICE1
			L_OPTION1PRICE2
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

deferred class
	PP_NUMBERED_VARIABLE_PARAMETER_LIST

inherit
	EL_HTTP_PARAMETER_LIST
		rename
			make as make_list,
			extend as extend_list
		end

	PP_NUMBERED_VARIABLE_NAME_SEQUENCE
		undefine
			copy, is_equal
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		do
			Precursor (a_number)
			make_size (5)
		end

feature -- Element change

	extend (value: ZSTRING)
		do
			extend_list (create {EL_HTTP_NAME_VALUE_PARAMETER}.make (new_name, value))
		end

end
