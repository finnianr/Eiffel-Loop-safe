note
	description: "Copy file command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "6"

deferred class
	EL_COPY_FILE_COMMAND_I

inherit
	EL_FILE_RELOCATION_COMMAND_I
		redefine
			source_path
		end

feature -- Access

	source_path: EL_FILE_PATH

feature -- Status query

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := False
		end
end
