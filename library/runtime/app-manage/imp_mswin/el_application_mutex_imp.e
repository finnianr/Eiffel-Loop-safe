note
	description: "Windows implementation of [$source EL_APPLICATION_MUTEX_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_WINDOWS_MUTEX_API

	EXECUTION_ENVIRONMENT

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make_default
		do
		end

feature -- Status change

	try_lock (name: ZSTRING)
		local
			wide_name: EL_C_WIDE_CHARACTER_STRING
		do
			create wide_name.make_from_string (name.to_unicode)
			mutex_ptr := c_open_mutex (wide_name.base_address)
			if not is_attached (mutex_ptr) then
				mutex_ptr := c_create_mutex (wide_name.base_address)
				if is_attached (mutex_ptr) then
					is_locked := True
				end
			end
		end

	unlock
		local
			closed: BOOLEAN
		do
			if is_attached (mutex_ptr) then
				closed := c_close_handle (mutex_ptr)
				is_locked := True
			end
		end

feature {NONE} -- Implementation

	mutex_ptr: POINTER

end
