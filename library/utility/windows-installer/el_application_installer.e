note
	description: "Windows application installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 13:07:08 GMT (Monday 22nd May 2017)"
	revision: "3"

deferred class
	EL_APPLICATION_INSTALLER

inherit
	EXECUTION_ENVIRONMENT
		rename
			current_working_directory as install_files_root
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create shell_link.make
		end

feature -- Access

	program_menu_path: EL_DIR_PATH

feature -- Element change

	 set_application_home (an_application_home: like application_home)
			--
		do
			application_home := an_application_home
		end

	set_desktop_shortcut (a_desktop_shortcut: like has_desktop_shortcut)
			-- Set `has_desktop_shortcut' to `a_desktop_shortcut'.
		do
			has_desktop_shortcut := a_desktop_shortcut
		ensure
			desktop_shortcut_assigned: has_desktop_shortcut = a_desktop_shortcut
		end

	set_program_menu_path (a_program_menu_path: like program_menu_path)
			-- Set `program_menu_path' to `a_program_menu_path'.
		do
			program_menu_path := a_program_menu_path
		ensure
			program_menu_path_assigned: program_menu_path = a_program_menu_path
		end

feature -- Access

	application_home: EL_DIR_PATH

feature -- Basic operations

	install
			--
		require
			application_home_is_set: application_home /= Void
		local
			program_file_link_path: EL_FILE_PATH
			target_path: EL_FILE_PATH
		do
			log.enter ("install")
			File_system.make_directory (application_home)
			File_system.make_directory (program_menu_path)

			across File_source_directories as path loop
				place_files_in_destination (path.item)
			end
			target_path := application_home + Launch_command_relative_path

			shell_link.load (File_link_path)
			shell_link.set_target_path (target_path)
			if not Launch_command_arguments.is_empty then
				shell_link.set_command_arguments (Launch_command_arguments)
			end
			shell_link.set_working_directory (target_path.parent)
			shell_link.set_icon_location (Shell_link_icon_path, 1)

			program_file_link_path := program_menu_path + Launch_shortcut_name
			program_file_link_path.add_extension ("lnk")

			shell_link.save (program_file_link_path)
			if has_desktop_shortcut then
				shell_link.save (Desktop_link_path)
			end
			log.exit
		end

feature {NONE} -- Implementation

	place_files_in_destination (directory: ZSTRING)
			--
		local
			l_command: EL_OS_COMMAND
			source_path, destination_path: EL_DIR_PATH
			source_drive, destination_drive: CHARACTER_32
		do
			log.enter_with_args ("place_files_in_destination", << directory >>)
			create source_path.make (install_files_root)
			source_path.append_step (directory)
			create destination_path.make (application_home)

			source_drive := source_path.first_step [1]
			destination_drive := application_home.first_step [1]

			if source_drive = destination_drive then
				l_command := (Move_directory_command)
			else
				l_command := (Copy_directory_command)
				destination_path.append_step (directory)
			end
			l_command.put_directory_path ("source", source_path)
			l_command.put_directory_path ("application_home", destination_path)
			l_command.execute
			log.exit
		end

	has_desktop_shortcut: BOOLEAN

	shell_link: EL_SHELL_LINK

	source: STRING

	File_link_path: EL_FILE_PATH
			-- relative to installation root
		local
			l_dir: EL_DIR_PATH
		do
			l_dir := install_files_root
			Result := l_dir + File_link_relative_path
		end

feature -- Constants

	Default_application_home: STRING
			--
		deferred
		end

	Default_menu_folder_name: STRING
			--
		deferred
		end

	Launch_shortcut_name: STRING
			--
		deferred
		end

	Desktop_link_path: EL_FILE_PATH
			--
		once
			create Result.make (item ("USERPROFILE"))
			Result.append_step ("Desktop")
			Result.append_step (Launch_shortcut_name)
			Result.add_extension ("lnk")
		end

	File_source_directories: ARRAY [STRING]
			--
		deferred
		end

	File_link_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Launch_command_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Launch_command_arguments: STRING
			-- Arguments to launch command
		once
			create Result.make_empty
		end

	Executable_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Shell_link_icon_path: EL_FILE_PATH
			--
		once
			Result := application_home + Executable_relative_path
		end

feature {NONE} -- OS commands

	Copy_directory_command: EL_OS_COMMAND
		once
			create Result.make ("xcopy /I /S /Y %"$source%" %"$application_home%"")
		end

	Move_directory_command: EL_OS_COMMAND
		once
			create Result.make ("move /Y %"$source%" %"$application_home%"")
		end

feature -- Window  constants

	Window_title: STRING
			--
		deferred
		end

	Window_icon: EV_PIXMAP
			--
		deferred
		end

	Application_logo_pixmap: EV_PIXMAP
			--
		deferred
		end

	Application_icons: EL_APPLICATION_ICON
			--
		once
			create Result
		end

end
