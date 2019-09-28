note
	description: "Iteration cursor for node context list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_XPATH_NODE_CONTEXT_LIST_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [EL_XPATH_NODE_CONTEXT]
		rename
			item as node
		end

create
	make

feature {NONE} -- Initialization

	make (a_context_list: EL_XPATH_NODE_CONTEXT_LIST)
		do
			create node.make_from_other (a_context_list.parent_context)
			xpath := a_context_list.xpath
		end

feature -- Access

	node: EL_XPATH_NODE_CONTEXT
			-- node context at current cursor position.

	cursor_index: INTEGER

	xpath: READABLE_STRING_GENERAL

feature -- Status report	

	after: BOOLEAN
			--
		do
			Result := not node.match_found
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			cursor_index := 0
			node.query_start (xpath)
			cursor_index := cursor_index + 1
		end

	forth
			--
		do
			node.query_forth
			cursor_index := cursor_index + 1
		end
end
