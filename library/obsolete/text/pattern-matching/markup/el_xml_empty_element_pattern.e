note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-14 19:00:11 GMT (Monday 14th December 2015)"
	revision: "1"

class
	EL_XML_EMPTY_ELEMENT_PATTERN

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_pattern
		end

	EL_XML_PATTERN_FACTORY
		undefine
			default_create, Default_match_action
		end

create
	make

feature {NONE} -- Initialization

	make (tag_name: STRING; attributes: EL_MATCH_ZERO_OR_MORE_TIMES_TP)
			--
		do
--			make_from_other (named_opening_element (tag_name,"/>", attributes) )
			set_name ("empty_element (%"" + tag_name + "%")")
		end


end -- class XML_EMPTY_ELEMENT_PATTERN
