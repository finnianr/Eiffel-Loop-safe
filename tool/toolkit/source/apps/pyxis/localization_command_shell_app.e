note
	description: "[
		Command shell to perform queries and edits on tree of Pyxis localization files

		**Usage**
		
			el_toolkit -localization_shell -source <source tree directory>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:26:04 GMT (Wednesday   25th   September   2019)"
	revision: "11"

class
	LOCALIZATION_COMMAND_SHELL_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [LOCALIZATION_COMMAND_SHELL]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Localization directory tree path", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "localization_shell"

	Description: STRING = "Command shell to perform queries and edits on tree of Pyxis localization files"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{LOCALIZATION_COMMAND_SHELL_APP}, All_routines],
				[{LOCALIZATION_COMMAND_SHELL_TEST_SET}, All_routines]
			>>
		end

	Visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			Result := << {EL_FTP_PROTOCOL} >>
		end

end
