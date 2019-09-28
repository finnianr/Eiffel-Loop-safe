note
	description: "[
		Constants base on [http://www.nsftools.com/tips/RawFTP.htm list of raw ftp commands]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_FTP_COMMAND_ROUTINES

feature -- Access

	make_directory (dir: EL_DIR_PATH): ZSTRING
		do
			Result := Make_directory_template #$ [dir]
		end

	change_directory (dir: EL_DIR_PATH): ZSTRING
		do
			Result := Change_working_directory_template #$ [dir]
		end

	delete_file (file_path: EL_FILE_PATH): ZSTRING
		do
			Result := Delete_file_template #$ [file_path]
		end

	remove_directory (dir: EL_DIR_PATH): ZSTRING
		do
			Result := Remove_directory_template #$ [dir]
		end

	size (path: EL_PATH): ZSTRING
		do
			Result := Get_size_template #$ [path]
		end

feature -- Constants

	Print_working_directory: ZSTRING
		once
			Result := "PWD"
		end

	Quit: ZSTRING
		once
			Result := "QUIT"
		end

feature {NONE} -- Constants

	Get_size_template: ZSTRING
		once
			Result := "SIZE %S"
		end

	Change_working_directory_template: ZSTRING
		once
			Result := "CWD %S"
		end

	Delete_file_template: ZSTRING
		once
			Result := "DELE %S"
		end

	Make_directory_template: ZSTRING
		once
			Result := "MKD %S"
		end

	Remove_directory_template: ZSTRING
		once
			Result := "RMD %S"
		end

	Path_escaper: EL_BASH_PATH_ZSTRING_ESCAPER
		once
			create Result.make
		end
end
