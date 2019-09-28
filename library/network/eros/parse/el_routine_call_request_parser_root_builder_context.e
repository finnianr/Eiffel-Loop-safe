note
	description: "Routine call request parser root builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT
		redefine
			make, reset
		end

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
			--
		do
			create call_request_string.make_empty
			Precursor (a_root_node_xpath, a_target)
		end

feature -- Access

	call_request_string: STRING

feature -- Element change

	reset
			-- Reset builder
		do
			Precursor
			call_request_string.clear_all
			building_actions.extend (agent set_call_request_string, Xpath_processing_instruction_call)
		end

feature {NONE} -- Implementation

	set_call_request_string
			--
		do
			call_request_string := node.to_string
		end

	Xpath_processing_instruction_call: STRING = "processing-instruction('call')"

end
