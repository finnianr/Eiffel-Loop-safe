note
	description: "String 32 edition history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:05:35 GMT (Monday 1st July 2019)"
	revision: "7"

class
	EL_ZSTRING_EDITION_HISTORY

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

	EL_STRING_EDITION_HISTORY_ABLE [ZSTRING]
		undefine
			is_equal, copy
		redefine
			extend,
			wipe_out,
			make
		end

	EL_MODULE_ZSTRING

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			--<Precursor>
		do
			create area_v2.make_empty (n)
			Precursor (n)
		end

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

feature -- Element change

	set_string_from_general (general: READABLE_STRING_GENERAL)
		do
			set_string (Zstring.as_zstring (general))
		end

	extend_from_general (general: READABLE_STRING_GENERAL)
		do
			extend (Zstring.as_zstring (general))
		end

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		do
			string.insert_character (c, start_index)
			caret_position := start_index + 1
		end

	insert_string (s: ZSTRING; start_index: INTEGER)
		do
			string.insert_string (s, start_index)
			caret_position := start_index + s.count
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			string.remove_substring (start_index, end_index)
			caret_position := start_index
		end

	replace_substring (s: ZSTRING; start_index, end_index: INTEGER)
		do
			string.replace_substring (s, start_index, end_index)
			caret_position := start_index + 1
		end

end
