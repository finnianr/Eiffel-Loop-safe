note
	description: "[
		Application to execute file tree transformation scripts.

		See class [$source FILE_TREE_TRANSFORMER_SCRIPT]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:26:02 GMT (Wednesday   25th   September   2019)"
	revision: "6"

class
	FILE_TREE_TRANSFORM_SCRIPT_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [FILE_TREE_TRANSFORMER_SCRIPT]
		redefine
			initialize, Option_name
		end

feature {NONE} -- Initialization

	initialize
		do
			Console.show ({FILE_TREE_TRANSFORMER_SCRIPT})
			Precursor
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("script", "Path to Pyxis transform script")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_INPUT_PATH [EL_FILE_PATH]})
		end

feature {NONE} -- Constants

	Option_name: STRING = "transform_tree"

	Description: STRING = "Transforms a tree of files using command parameters in a Pyxis script"

end
