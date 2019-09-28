note
	description: "Module win registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 14:18:00 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_WIN_REGISTRY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Win_registry: EL_WINDOWS_REGISTRY_ROUTINES
		once
			create Result
		end
end
