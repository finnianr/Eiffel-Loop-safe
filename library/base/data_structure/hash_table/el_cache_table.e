note
	description: "Table to cache results of `new_item' creation procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-20 13:25:25 GMT (Sunday 20th January 2019)"
	revision: "1"

class
	EL_CACHE_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make_equal as make_equal_table,
			item as cached_item,
			remove as remove_type
		end

create
	make_equal, make

feature {NONE} -- Initialization

	make_equal (n: INTEGER; a_new_item: like new_item)
		do
			make_equal_table (n)
			new_item := a_new_item
		end

feature -- Access

	item (key: K): like cached_item
			-- Returns the cached value of `new_item (key)' if available, or else
			-- the actual value
		do
			if has_key (key) then
				Result := found_item
			else
				Result := new_item (key)
				check has_result: attached Result as al_result then
					extend (al_result, key)
				end
			end
		end

feature {NONE} -- Initialization

	new_item: FUNCTION [K, G]

end
