note
	description: "[
		list of strings that should be rendered with either a regular, bold or fixed font
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_MIXED_STYLE_TEXT_LIST

inherit
	ARRAYED_LIST [EL_STYLED_TEXT]

create
	make, make_from_array

end
