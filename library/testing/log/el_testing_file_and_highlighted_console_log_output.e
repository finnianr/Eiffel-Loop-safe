note
	description: "Extends [$source EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:30:44 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		rename
			make as make_file_and_console
		export
			{ANY} extendible
		undefine
			put_file_string
		end

	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT
		undefine
			set_text_blue, set_text_brown, set_text_dark_gray, set_text_default, set_text_light_blue,
			set_text_light_cyan, set_text_light_green, set_text_purple, set_text_red,
			flush_string_8
		end

create
	make

end
