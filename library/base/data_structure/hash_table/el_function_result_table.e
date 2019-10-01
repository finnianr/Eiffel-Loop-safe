note
	description: "[
		Object for caching the result of a call to function `new_item' for each
		generating type of the generic parameter `TARGET'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:13:35 GMT (Monday 1st July 2019)"
	revision: "4"

class
	EL_FUNCTION_RESULT_TABLE [TARGET, R]

inherit
	HASH_TABLE [R, INTEGER]
		rename
			make as make_count,
			item as cached_item,
			remove as remove_type
		end

	EL_MODULE_EIFFEL

create
	make, make_count

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item)
		require
			target_open: not a_new_item.is_target_closed
		do
			make_count (n)
			internal_new_item := a_new_item
		end

feature -- Access

	item (target: TARGET): like cached_item
			-- Returns a `new_item' or else the `cached_item' for the generating type of `target'
		local
			type_id: INTEGER
		do
			check separate_target: attached {separate ANY} target as al_target then
				type_id := Eiffel.dynamic_type (al_target)
			end
			if has_key (type_id) then
				Result := found_item
			else
				check has_result: attached new_item (target) as al_result then
					Result := al_result
					extend (Result, type_id)
				end
			end
		end

feature -- Removal

	remove (object: TARGET)
		do
			check has_object: attached {TARGET} object as al_object then
				remove_type (Eiffel.dynamic_type (al_object))
			end
		end

feature {NONE} -- Initialization

	new_item: FUNCTION [TARGET, R]
		do
			check attached internal_new_item as al_new_item then Result := al_new_item end
		end

	internal_new_item: detachable like new_item

end
