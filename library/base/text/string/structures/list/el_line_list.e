note
	description: "Line list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LINE_LIST [S -> STRING_GENERAL create make_empty end]

inherit
	EL_LINEAR [S]

create
	make

feature {NONE} -- Initialization

	make (a_target: S)
			--
		do
			target := a_target
			delimiter := Default_delimiter
		end

feature -- 19.05 Issues

	new_cursor: ITERATION_CURSOR [S]
			-- <Precursor>
			-- New {ITERATION_CURSOR} based on Current.
		do
			check attached internal_new_cursor as al_result then Result := al_result end
		end

	internal_new_cursor: detachable like new_cursor

feature -- Access

	index: INTEGER

	item: S
			--
		do
			if not after then
				Result := target.substring (pos_previous_separator + 1, pos_separator - 1)
			else
				create Result.make_empty
			end
		end

	delimiter: CHARACTER_32

feature -- Element change

	set_delimiter (a_delimiter: CHARACTER_32)
			--
		do
			delimiter := a_delimiter
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			index := 0
			pos_previous_separator := 0
			pos_separator := 0
			after := false
			forth
		end

	forth
			-- Move to next position
		do
			if pos_separator > target.count then
				after := true
			else
				pos_previous_separator := pos_separator
				pos_separator := target.index_of (delimiter, pos_previous_separator + 1)
				if pos_separator = 0 then
					pos_separator := target.count + 1
				end
			end
			index := index + 1
		end

feature -- Status query

	after: BOOLEAN

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := target.is_empty
		end

feature {NONE} -- Implementation

	target: S

	pos_separator: INTEGER

	pos_previous_separator: INTEGER

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {NONE} -- Constant

	Default_delimiter: CHARACTER = '%N'

end
