note
	description: "Function id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_FUNCTION_ID

inherit
	FUNCTION [ANY]
		export
			{NONE} all
			{ANY} deep_copy,
				deep_twin,
				is_deep_equal,
				standard_is_equal,
				adapt, written_type_id_inline_agent, is_target_closed, calc_rout_addr,
				last_result, rout_disp, routine_id, operands, closed_operands, open_count,
				is_basic, callable
			{EL_FUNCTION_ID} encaps_rout_disp
		redefine
			is_equal
		end

create
	make, default_create

feature -- Initialization

	make (other: FUNCTION [ANY])
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end
