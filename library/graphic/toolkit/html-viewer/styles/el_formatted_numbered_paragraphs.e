note
	description: "Formatted numbered paragraphs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-09 12:58:33 GMT (Wednesday 9th January 2019)"
	revision: "6"

class
	EL_FORMATTED_NUMBERED_PARAGRAPHS

inherit
	EL_FORMATTED_BULLETED_PARAGRAPHS
		rename
			make as make_paragraph,
			bullet_text as numbered_text
		redefine
			numbered_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like styles; a_block_indent, a_index: INTEGER)
		do
			make_paragraph (a_style, a_block_indent)
			index := a_index
		end

feature -- Access

	index: INTEGER

feature -- Element change

	set_index (a_index: like index)
		do
			index := a_index
		end

feature {NONE} -- Implementation

	numbered_text: ZSTRING
		do
			Result := index.out + "."
		end
end
