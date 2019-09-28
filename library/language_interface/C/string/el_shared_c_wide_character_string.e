note
	description: "Shared c wide character string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 14:16:51 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_C_WIDE_CHARACTER_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	wide_string (a_native_string: POINTER): EL_C_WIDE_CHARACTER_STRING
		do
			if a_native_string = Default_pointer then
				create Result
			else
				Result := Internal_wide_string
				Result.set_owned_from_c (a_native_string)
			end
		end

feature {NONE} -- Constants

	Internal_wide_string: EL_C_WIDE_CHARACTER_STRING
		once
			create Result
		end
end
