note
	description: "Logged command line sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 2:30:09 GMT (Friday 25th January 2019)"
	revision: "2"

deferred class
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]
		rename
			init_console as init_console_and_logging
		undefine
			new_lio, do_application, init_console_and_logging, io_put_header, standard_options
		end

	EL_LOGGED_SUB_APPLICATION
end
