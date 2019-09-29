note
	description: "Functions by result type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 17:17:36 GMT (Tuesday 10th September 2019)"
	revision: "1"

class
	EL_FUNCTIONS_BY_RESULT_TYPE

inherit
	HASH_TABLE [FUNCTION [ANY], INTEGER_32]
		rename
			make as make_table
		end

create
	make,
	make_table

feature {NONE} -- Initialization

	make (functions: ARRAY [like item])
		do
			make_table (functions.count)
			extend_from_array (functions)
		end

feature -- Element change

	extend_from_array (functions: ARRAY [like item])
		do
			across functions as f loop
				check has_param: attached f.item.generating_type.generic_parameter_type (2) as al_param and then
					attached f as al_f and then attached al_f.item as al_item
				then
					put (al_item, al_param.type_id)
				end
			end
		end

end
