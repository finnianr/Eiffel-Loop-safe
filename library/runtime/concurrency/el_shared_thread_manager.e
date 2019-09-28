note
	description: "Shared thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:34 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_SHARED_THREAD_MANAGER

inherit
	EL_ANY_SHARED

feature {NONE} -- Factory

	new_manager: EL_THREAD_MANAGER
		do
			create Result
		end

feature {NONE} -- Constant

	Thread_manager: EL_THREAD_MANAGER
			--
		once ("PROCESS")
			Result := new_manager
		end

end
