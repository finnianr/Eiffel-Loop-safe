note
	description: "Integer range list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:43:10 GMT (Friday 18th January 2019)"
	revision: "4"

class
	INTEGER_RANGE_LIST_PARAMETER

inherit
	LIST_PARAMETER [ARRAYED_LIST [INTEGER]]
		redefine
			building_action_table, display_item
		end

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_string ("Integer range [")
			log.put_integer (index)
			log.put_string ("]: ")
			from item.start until item.after loop
				log.put_integer (item.item)
				log.put_string (" ")
				item.forth
			end
			log.put_new_line
		end

feature {NONE} -- Implementation

	last_integer_range: like item

feature {NONE} -- Build from XML

	add_integer_range
			--
		local
			integer_list: EL_ZSTRING_LIST
		do
			create integer_list.make_with_separator (node.to_string, ',', False)
			create last_integer_range.make (integer_list.count)
			across integer_list as str loop
				last_integer_range.extend (str.item.to_integer)
			end
			extend (last_integer_range)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent add_integer_range]
			>>)
		end

end
