note
	description: "Some standard command-line word options for Eiffel-Loop"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-05 9:51:21 GMT (Sunday 5th May 2019)"
	revision: "11"

class
	EL_COMMAND_OPTIONS

feature -- Constants

	Ask_user_to_quit: STRING = "ask_user_to_quit"
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	Help: STRING = "help"

	Install: STRING = "install"

	No_app_header: STRING = "no_app_header"

	No_highlighting: STRING = "no_highlighting"
		-- turns off logging color highlighting

	Silent: STRING = "silent"

	Uninstall: STRING = "uninstall"

end
