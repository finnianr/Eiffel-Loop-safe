note
	description: "Implementation of [$source EL_CPU_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_CPU_INFO_COMMAND_IMP

inherit
	EL_CPU_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			is_valid_platform
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default, do_command, new_command_string
		redefine
			is_valid_platform
		end

create
	make, make_default

feature {NONE} -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Implementation

	Template: STRING = "[
		cat /proc/cpuinfo | grep "model name" --max-count 1
	]"

end
