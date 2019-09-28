note
	description: "[
		Name-value pair that sets an environment variable when applied.
		If the
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:45:18 GMT (Monday 1st July 2019)"
	revision: "4"

class
	EL_ENVIRON_VARIABLE

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make, make_from_string, default_create

feature {NONE} -- Initialization

	default_create
		do
			create name.make_empty
			create value.make_empty
		end

	make (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
		end

	make_from_string (str: ZSTRING)
		require
			splittable_by_equal_sign: str.occurrences ('=') = 1 and then across str.split ('=') as s all s.item.count > 0 end
		local
			parts: LIST [ZSTRING]
		do
			parts := str.split ('=')
			if parts.count = 2 then
				make (parts.first, parts.last)
			else
				default_create
			end
		end

feature -- Access

	name: ZSTRING

	value: ZSTRING

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := not name.is_empty
		end

feature -- Basic operations

	apply
		do
			if is_valid then
				Execution_environment.put (general_value, name.to_string_32)
			end
		end

feature {NONE} -- Implementation

	general_value: READABLE_STRING_GENERAL
		do
			Result := value.to_string_32
		end
end
