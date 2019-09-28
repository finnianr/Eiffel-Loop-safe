note
	description: "Path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-04 9:12:25 GMT (Wednesday 4th September 2019)"
	revision: "9"

class
	PATH_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

feature -- Tests

	test_joined_steps
		note
			testing: "covers/{EL_PATH}.make_from_path"
		local
			home_path, config_path: EL_DIR_PATH
		do
			home_path := "/home"
			config_path := home_path.joined_dir_steps (<< "finnian", ".config" >>)
			assert ("same path", config_path.to_string.to_latin_1 ~ "/home/finnian/.config")
		end

	test_universal_relative_path
		local
			path_1, relative_path: EL_FILE_PATH; path_2: EL_DIR_PATH
		do
			log.enter ("test_universal_relative_path")
			across OS.file_list (Eiffel_dir, "*.e") as p1 loop
				path_1 := p1.item.relative_path (Eiffel_dir)
				log.put_path_field ("class", path_1)
				log.put_new_line
				across OS.directory_list (Eiffel_dir) as p2 loop
					if Eiffel_dir.is_parent_of (p2.item) then
						path_2 := p2.item.relative_path (Eiffel_dir)
						relative_path := path_1.universal_relative_path (path_2)

						Execution_environment.push_current_working (p2.item)
						assert ("Path exists", relative_path.exists)
						Execution_environment.pop_current_working
					end
				end
			end
			log.exit
		end

	test_parent_of
		local
			dir_home, dir: EL_DIR_PATH; dir_string, dir_string_home: ZSTRING
			is_parent: BOOLEAN
		do
			create dir_string.make_empty
			dir_string_home := "/home/finnian"
			dir_home := dir_string_home
			across Path_string.split ('/') as step loop
				if step.cursor_index > 1 then
					dir_string.append_character ('/')
				end
				dir_string.append (step.item)
				dir := dir_string
				is_parent := dir_string.starts_with (dir_string_home) and dir_string.count > dir_string_home.count
				assert ("same result", is_parent ~ dir_home.is_parent_of (dir))
			end
		end

	test_is_absolute
		note
			testing:	"covers/{EL_PATH}.is_absolute"
		do

		end

feature {NONE} -- Constants

	Path_string: ZSTRING
		once
			Result := "/home/finnian/Documents/Eiffel"
		end

	Eiffel_dir: EL_DIR_PATH
		once
			Result := "$EIFFEL_LOOP/tool/eiffel/test-data"
			Result.expand
		end

end
