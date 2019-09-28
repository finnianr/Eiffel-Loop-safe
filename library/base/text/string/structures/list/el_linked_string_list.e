note
	description: "Linked string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_GENERAL_CHAIN [S]
		rename
			accommodate as grow
		undefine
			is_equal, copy, is_inserted, prune_all, readable, prune, new_cursor, first, last,
			start, finish, move, go_i_th, isfirst, islast, off, remove
		end

	LINKED_LIST [S]
		rename
			append as append_sequence,
			make as make_empty
		end

create
	make_empty, make_with_separator, make_with_lines, make_with_words

feature {NONE} -- Unused

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		do
		end

end
