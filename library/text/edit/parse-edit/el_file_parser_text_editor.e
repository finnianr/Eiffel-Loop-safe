note
	description: "[
		Text editor that searchs for a grammatical pattern. The pattern event handler is reponsible for
		sending modified text to the output. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

deferred class
	EL_FILE_PARSER_TEXT_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			make_default
		end

	EL_PARSER_TEXT_EDITOR
		redefine
			make_default
		end

	EL_FILE_PARSER
		rename
			set_source_text_from_file as set_file_path,
			source_file_path as file_path,
			new_pattern as delimiting_pattern,
			find_all as put_editions
		undefine
			Default_file_path
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_FILE_PARSER}
			Precursor {EL_PARSER_TEXT_EDITOR}
		end

end
