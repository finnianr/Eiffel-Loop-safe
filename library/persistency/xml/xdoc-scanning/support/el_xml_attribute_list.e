note
	description: "Xml attribute list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XML_ATTRIBUTE_LIST

inherit
	ARRAYED_LIST [EL_XML_ATTRIBUTE_NODE]
		rename
			make as make_list,
			item as node,
			last as last_node,
			extend as extend_list,
			wipe_out as reset
		export
			{NONE} all
			{ANY} default_pointer,
				start, after, forth, count, node, is_empty, i_th, first, last_node, index, go_i_th, reset

		redefine
			all_default
		end

	EL_XML_NODE_CLIENT
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_list (Default_size)
			create node_cache.make (Default_size)
			from until node_cache.full loop
				node_cache.extend (create {like node})
			end
			reset
		end

feature -- Element change

	extend
			--
		do
			if count = node_cache.upper then
				node_cache.extend (create {like node})
			end
			extend_list (node_cache [count + 1])
			finish
		end

feature {NONE} -- Implementation

	node_cache: ARRAYED_LIST [like node]

feature -- Constants

	Default_size: INTEGER = 5

	All_default: BOOLEAN = True

end