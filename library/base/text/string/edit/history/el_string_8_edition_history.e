note
	description: "String 8 edition history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-04 17:31:47 GMT (Monday 4th February 2019)"
	revision: "6"

class
	EL_STRING_8_EDITION_HISTORY

inherit
	ARRAYED_STACK [EL_STRING_EDITION]
		rename
			extend as list_extend,
			make as make_array,
			item as edition_item
		redefine
			wipe_out,
			new_filled_list
		end

	EL_STRING_EDITION_HISTORY_ABLE [STRING_8]
		undefine
			is_equal, copy
		redefine
			extend,
			wipe_out
		end

create
	make

feature -- 19.05

	wipe_out
			--<Precursor>
		do
			Precursor {ARRAYED_STACK}
			Precursor {EL_STRING_EDITION_HISTORY_ABLE}
		end

	extend (a_string: like string)
		do
			put (new_edition (string, a_string))
			Precursor (a_string)
		end

	undo
		do
			restore (Current, redo_stack)
		end

	redo
		do
			restore (redo_stack, Current)
		end

	new_filled_list (n: INTEGER): like Current
			--<Precursor>
		do
			Result := Precursor (n)
		end

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		do
			string.insert_character (c.to_character_8, start_index)
			caret_position := start_index + 1
		end

	insert_string (s: STRING_8; start_index: INTEGER)
		do
			string.insert_string (s, start_index)
			caret_position := start_index + s.count
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			string.remove_substring (start_index, end_index)
			caret_position := start_index
		end

	replace_substring (s: STRING_8; start_index, end_index: INTEGER)
		do
			string.replace_substring (s, start_index, end_index)
			caret_position := start_index + 1
		end

end
