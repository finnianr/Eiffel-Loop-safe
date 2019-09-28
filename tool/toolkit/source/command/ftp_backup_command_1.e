note
	description: "Ftp backup"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 18:24:52 GMT (Monday 9th September 2019)"
	revision: "10"

class
	FTP_BACKUP_COMMAND_1

inherit
	EL_COMMAND

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_MODULE_PYXIS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_file_path_list: EL_FILE_PATH_LIST; a_ask_user_to_upload: BOOLEAN)
		do
			create config_list.make (config_file_path_list.count)
			across config_file_path_list as path loop
				config_list.extend (create {BACKUP_CONFIG}.make (path.item))
			end

			ask_user_to_upload := a_ask_user_to_upload
			create archive_upload_list.make
		end

feature -- Status query

	ask_user_to_upload: BOOLEAN

feature -- Basic operations

	backup_all
			--
		local
			target_directory_path: EL_DIR_PATH
		do
			log.enter ("backup_all")
			across root_node.context_list ("/backup-script/directory") as l_directory loop
				if l_directory.node.has ("path")  then
					target_directory_path := l_directory.node.string_32_at_xpath ("path")

					if not target_directory_path.is_absolute then
						target_directory_path := script_file_path.parent.joined_dir_path (target_directory_path)
					end

					if target_directory_path.exists then
						backup_directory (l_directory.node, target_directory_path)
					else
						lio.put_path_field ("ERROR: no such directory", target_directory_path)
						lio.put_new_line
					end
				else
					lio.put_line ("ERROR: missing path node")
				end
			end
			log.exit
		end

	backup_directory (directory_node: EL_XPATH_NODE_CONTEXT; target_directory_path: EL_DIR_PATH)
			--
		require
			target_directory_path_exists: target_directory_path.exists
		local
			backup_name: STRING
			archive_dir_path, ftp_destination_directory: EL_DIR_PATH
			archive_file_path: EL_FILE_PATH
			archive_file: ARCHIVE_FILE
		do
			log.enter ("backup_directory")
			lio.put_path_field ("Backup", target_directory_path)
			lio.put_new_line

			backup_name := directory_node.string_at_xpath ("name")
			if backup_name.is_empty then
				backup_name := target_directory_path.base
			end

			archive_dir_path := script_file_path.parent.joined_dir_steps (<< "tar.gz", backup_name >>)
			File_system.make_directory (archive_dir_path)

--			create archive_file.make (directory_node, target_directory_path, archive_dir_path, backup_name)
			total_byte_count := total_byte_count + archive_file.byte_count
			archive_file_path := archive_file.file_path
			lio.put_path_field ("Creating archive", archive_file_path); lio.put_new_line

			if archive_file_path.exists then
				 ftp_destination_directory := directory_node.string_32_at_xpath ("ftp-destination-path")

				if not ftp_destination_directory.is_empty then
					log.put_new_line
					log.put_path_field ("ftp-destination", ftp_destination_directory)
					log.put_new_line
					archive_upload_list.extend (
						create {EL_FTP_UPLOAD_ITEM}.make (archive_file_path, ftp_destination_directory)
					)
				end
			end
			log.exit
		end

	execute
			--
		local
			total_size_mega_bytes: REAL; ftp_site_node: EL_XPATH_NODE_CONTEXT
			website: EL_FTP_WEBSITE; config_file_path_list: EL_FILE_PATH_LIST
		do
			across config_file_path_list as l_path loop
				script_file_path := l_path.item
				if not script_file_path.is_absolute then
					script_file_path := Directory.current_working + script_file_path
				end
				set_root_node (script_file_path)
				backup_all
				total_size_mega_bytes := (total_byte_count / 1000_000).truncated_to_real

				root_node.find_node ("/backup-script/ftp-site")
				if root_node.node_found then
					ftp_site_node := root_node.found_node
					lio.put_new_line
					if total_size_mega_bytes > Max_mega_bytes_to_send then
						lio.put_string ("WARNING, total backup size ")
						lio.put_real (total_size_mega_bytes)
						lio.put_string (" megabytes exceeds limit (")
						lio.put_real (Max_mega_bytes_to_send)
						lio.put_string (")")
						lio.put_new_line
					end
				end
			end
			if ask_user_to_upload then
				lio.put_string ("Copy files offsite? (y/n) ")
				if User_input.entered_letter ('y') then
--					create website.make_from_node (ftp_site_node)
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_upload_list)
					end
				end
			end
		end

feature -- Element change

	set_root_node (file_path: EL_FILE_PATH)
			--
		local
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
			pyxis_medium, xml_out_medium: EL_ZSTRING_IO_MEDIUM
		do
			create pyxis_medium.make_open_write (1024)
			Evolicity_templates.put_file (file_path, Pyxis.encoding (file_path))
--			Evolicity_templates.merge (file_path, environment_variables, pyxis_medium)

			create xml_out_medium.make_open_write (pyxis_medium.text.count)

			create xml_generator.make
			pyxis_medium.close
			pyxis_medium.open_read
			xml_generator.convert_stream (pyxis_medium, xml_out_medium)

			create root_node.make_from_string (xml_out_medium.text)
		end

	set_script_file_path (a_script_file_path: like script_file_path)
		do
			script_file_path  := a_script_file_path
		end

feature {NONE} -- Implementation: attributes

	archive_upload_list: LINKED_LIST [EL_FTP_UPLOAD_ITEM]

	config_list: ARRAYED_LIST [BACKUP_CONFIG]

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

	script_file_path: EL_FILE_PATH

	total_byte_count: NATURAL

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0

end
