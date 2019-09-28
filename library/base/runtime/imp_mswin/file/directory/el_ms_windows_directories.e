note
	description: "Ms windows directories"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_MS_WINDOWS_DIRECTORIES

inherit
	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY

feature -- Access

	Desktop_common: EL_DIR_PATH
		once
			Result := win_folder_path (Folder.common_desktop)
		end

	Desktop: EL_DIR_PATH
		once
			Result := win_folder_path (Folder.desktop)
		end

	User, User_profile_dir: EL_DIR_PATH
		once
			Result := win_folder_path (Folder.user_profile)
		end

	My_documents: EL_DIR_PATH
			--
		once
			Result := win_folder_path (Folder.my_documents)
		end

	Program_files_dir: EL_DIR_PATH
			--
		once
			Result := win_folder_path (Folder.program_files)
		end

	Start_menu_programs_dir: EL_DIR_PATH
		once
			Result := win_folder_path (Folder.common_programs)
		end

	System_dir: EL_DIR_PATH
			--
		once
			Result := win_folder_path (Folder.system)
		end

	Executable_extensions_spec: ZSTRING
		once
			Result := item ("PATHEXT")
		end

feature -- Constants

	max_path: INTEGER
			-- Maximum number of characters in path
		external
			"C [macro <limits.h>]"
		alias
			"MAX_PATH"
		end

feature {NONE} -- Implementation

	win_folder_path (folder_id: INTEGER): EL_DIR_PATH
		local
			folder_path: NATIVE_STRING; status_code: INTEGER
		do
			create folder_path.make_empty (max_path)
			status_code := c_shell32_get_folder_path (folder_id, folder_path.item)
			Result := folder_path.string
		end

feature {NONE} -- C Externals

	c_shell32_get_folder_path (folder_id: INTEGER; a_path_out: POINTER): INTEGER
			--
		external
			"C inline use <Shlobj.h>"
		alias
			"SHGetFolderPath (NULL, $folder_id, NULL, 0, $a_path_out)"
		end

feature {NONE} -- Constants

	Folder: EL_MS_WINDOWS_FOLDER_CONSTANTS
		once
			create Result
		end
end
