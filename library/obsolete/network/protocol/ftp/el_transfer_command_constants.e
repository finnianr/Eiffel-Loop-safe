note
	description: "Transfer command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_TRANSFER_COMMAND_CONSTANTS

feature {NONE} -- Constants for FTP

	Ftp_quit: STRING = "QUIT"

	Ftp_print_working_directory: STRING = "PWD"

	Ftp_change_working_directory: STRING = "CWD"

	Ftp_make_directory: STRING = "MKD"
		-- This command (make directory) causes a directory to be created.
		-- The name of the directory to be created is indicated in the parameters.
end