note
	description: "Application based on repository publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:25:36 GMT (Wednesday   25th   September   2019)"
	revision: "6"

deferred class
	REPOSITORY_PUBLISHER_SUB_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Path to publisher configuration file", << file_must_exist >>),
				required_argument ("version", "Repository version number"),
				optional_argument ("threads", "Number of threads to use for reading files")
			>>
		end

end
