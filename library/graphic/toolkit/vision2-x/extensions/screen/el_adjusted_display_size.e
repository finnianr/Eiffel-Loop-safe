note
	description: "[
		Read and writes user adjusted display size. Typically during installation the user adjusts a window
		to A5 paper size. This is used to accurately determine the display size in the event it cannot be
		accurately determined by system calls.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:47:07 GMT (Monday 1st July 2019)"
	revision: "4"

class
	EL_ADJUSTED_DISPLAY_SIZE

inherit
	ANY
	
	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_SCREEN

create
	make, make_directory

feature {NONE} -- Initialization

	make
		do
			make_default
			set_dir_path (Directory.app_configuration)
			if not file_path.exists then
				set_dir_path (Directory.Application_installation)
			end
		end

	make_default
		local
			dots_per_cm: REAL
		do
			width_cms := Screen.width_cms
			height_cms := Screen.height_cms

			-- On some Windows systems the correct EDID display size is missing
			-- with an erroneous figure of 255 being used instead
			-- For eg. Compaq Presario M5000 laptop with LPL0000 display

			if 10.0 <= width_cms and width_cms <= 200.0 then
				is_display_width_known := True
			else
				-- Display unlikely to be bigger than 2 metres or less than 10 cms
				-- so we make a best guess. Assume the monitor is 12 inches wide as an average
				dots_per_cm := (Base_dpi * Screen.width / Base_resolution / 2.54).rounded
				width_cms := Screen.width / dots_per_cm
				height_cms := Screen.height / dots_per_cm
				is_display_width_known := False
			end
		end

	make_directory (dir_path: EL_DIR_PATH)
		do
			make_default
			file_path := dir_path + Relative_path
		end

feature -- Access

	height_cms: REAL
			-- screen height in centimeters

	width_cms: REAL
			-- screen width in centimeters

feature -- Element change

	set_dir_path (dir_path: EL_DIR_PATH)
		do
			file_path := dir_path + Relative_path
		end

feature -- Status query

	is_display_width_known: BOOLEAN
		-- True if default display width is not used

feature -- Basic operations

	read
		do
			if file_path.exists then
				-- Use config provided by user during installation
				across File_system.plain_text (file_path).split (':') as size loop
					inspect size.cursor_index
						when 1 then
							width_cms := size.item.to_real
						when 2 then
							height_cms := size.item.to_real
					else
					end
				end
				is_display_width_known := True
			end
		end

	write
		local
			file: PLAIN_TEXT_FILE; dir: DIRECTORY
		do
			create dir.make_with_name (file_path.parent)
			if dir.is_writable then
				create file.make_open_write (file_path)
				file.put_real (width_cms)
				file.put_character (':')
				file.put_real (height_cms)
				file.close
			end
		end

feature {NONE} -- Internal attributes

	file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Base_dpi: INTEGER
		once
			Result := Base_resolution // 12 -- inches
		end

	Base_resolution: INTEGER = 1024

	Relative_path: EL_FILE_PATH
		once
			Result := "config/display-size-cms.txt"
		end

end
