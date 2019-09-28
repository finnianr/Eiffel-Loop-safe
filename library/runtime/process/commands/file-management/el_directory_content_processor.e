note
	description: "Directory content processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:51:37 GMT (Monday 1st July 2019)"
	revision: "8"

class
	EL_DIRECTORY_CONTENT_PROCESSOR

inherit
	ANY
	
	EL_MODULE_OS

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create input_file_relative_path_steps_list.make
		end

feature -- Access

	output_dir: EL_DIR_PATH

	input_dir: EL_DIR_PATH

feature -- Measurement

	count: INTEGER
			-- Total file to process

	remaining: INTEGER
			-- Files remaining to process
		do
			Result := input_file_relative_path_steps_list.count
		end

feature -- Element change

	set_output_dir (a_output_dir: like output_dir)
			-- Set `output_dir' to `an_output_dir'.
		do
			output_dir := a_output_dir
			output_dir_path_steps := a_output_dir
		ensure
			output_dir_assigned: output_dir = a_output_dir
		end

	set_input_dir (a_input_dir: like input_dir)
			-- Set `input_dir' to `an_input_dir'.
		do
			input_dir := a_input_dir
			input_dir_path_steps := a_input_dir
		ensure
			input_dir_assigned: input_dir ~ a_input_dir
		end

feature -- Basic operations

	do_all (
		file_processing_action: PROCEDURE [EL_FILE_PATH, EL_DIR_PATH, ZSTRING, ZSTRING]
		wild_card: STRING
	)
			-- Apply file processing action to every file from input dir
		local
			output_file_unqualified_name, output_file_extension: ZSTRING
			destination_dir_path: EL_DIR_PATH; input_file_path: EL_FILE_PATH
			input_file_path_steps, output_file_dir_path_steps: EL_PATH_STEPS
			dot_pos: INTEGER
		do
			create input_file_path_steps.make_with_count (20)
			create output_file_dir_path_steps.make_with_count (20)
			find_files (wild_card)
			from input_file_relative_path_steps_list.start until input_file_relative_path_steps_list.after loop
				input_file_path_steps.wipe_out
				output_file_dir_path_steps.wipe_out
				create input_file_path
				create destination_dir_path

				input_file_path_steps.append (input_dir_path_steps)
				input_file_path_steps.append (input_file_relative_path_steps_list.item)

				output_file_dir_path_steps.append (output_dir_path_steps)
				output_file_dir_path_steps.append (input_file_relative_path_steps_list.item)

				create output_file_unqualified_name.make_from_string (output_file_dir_path_steps.last)
				dot_pos := output_file_unqualified_name.last_index_of ('.', output_file_unqualified_name.count)
				if dot_pos > 0 then
					output_file_extension := output_file_unqualified_name.substring_end (dot_pos + 1)
					output_file_unqualified_name.remove_tail (output_file_extension.count + 1)
				else
					output_file_extension := ""
				end
				output_file_dir_path_steps.remove_tail (1)

				input_file_path := input_file_path_steps.as_file_path
				OS.File_system.make_directory (output_file_dir_path_steps)
				destination_dir_path := output_file_dir_path_steps.as_directory_path

				file_processing_action.call (
					[input_file_path, destination_dir_path, output_file_unqualified_name, output_file_extension]
				)
				input_file_relative_path_steps_list.remove
			end
		end


feature {NONE} -- Implementation

	find_files (wild_card: STRING)
			--
		local
			file_path_list: EL_FILE_PATH_LIST
			file_path_steps: EL_PATH_STEPS
			i: INTEGER
		do
			create file_path_list.make (OS.file_list (input_dir, wild_card))

			input_file_relative_path_steps_list.wipe_out
			across file_path_list as file_path loop
				file_path_steps := file_path.item.steps

				-- Make path relative to input dir
				from i := 1 until i > input_dir_path_steps.count loop
					file_path_steps.remove_head (1)
					i := i + 1
				end
				input_file_relative_path_steps_list.extend (file_path_steps)
			end
			count := input_file_relative_path_steps_list.count
		end

	input_file_relative_path_steps_list: LINKED_LIST [EL_PATH_STEPS]
			-- List of path's relative to input dir split by dir separator

	output_dir_path_steps: EL_PATH_STEPS

	input_dir_path_steps: EL_PATH_STEPS

end
