note
	description: "A queryable chain implemented as an arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 14:20:22 GMT (Monday 5th November 2018)"
	revision: "7"

class
	EL_QUERYABLE_ARRAYED_LIST [G]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			make, make_filled, make_from_array
		end

	EL_QUERYABLE_CHAIN [G]
		rename
			accommodate as grow
		undefine
			index_of, occurrences, do_all, do_if, for_all, search, copy,
			force, append_sequence, prune, prune_all, remove, swap, new_cursor,
			pop_cursor, push_cursor, to_array,
			-- item access
			i_th, at, last, first,
			-- Status query
			off, has, there_exists, is_equal, valid_index, is_inserted,
			-- Cursor movement
			move, start, finish, go_i_th, put_i_th, find_next_item
		end

create
	make, make_filled, make_from_array, make_from_sub_list

feature -- Initialization

	make (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
		do
			make_queryable
			Precursor (n)
		end

	make_filled (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
			-- This list will be full.
		do
			make_queryable
			Precursor (n)
		end

	make_from_array (a: ARRAY [G])
			-- Create list from array `a'.
		do
			make_queryable
			Precursor (a)
		end

end
