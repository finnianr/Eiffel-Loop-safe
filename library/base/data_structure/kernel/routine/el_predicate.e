note
	description: "Predicate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 10:01:34 GMT (Wednesday 14th November 2018)"
	revision: "6"

class
	EL_PREDICATE

inherit
	PREDICATE
		export
			{NONE} all
			{ANY} deep_copy,
				deep_twin,
				is_deep_equal,
				standard_is_equal,
				adapt, open_count, routine_id, last_result, is_target_closed, encaps_rout_disp,
				is_basic, calc_rout_addr, closed_operands, operands, rout_disp, callable,
				written_type_id_inline_agent, conforms_to
		end

create
	make, default_create

feature -- Initialization

	make (other: PREDICATE)
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Comparison

	same_predicate (other: PREDICATE): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end
