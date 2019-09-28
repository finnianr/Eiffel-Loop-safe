note
	description: "Array reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 12:08:20 GMT (Monday 17th December 2018)"
	revision: "5"

class
	EL_ARRAY_READER

feature {NONE} -- File input

	array_double_list_from_csv_file (file_path: EL_FILE_PATH): LIST [ARRAY [DOUBLE]]
			--
		local
			file_in: PLAIN_TEXT_FILE; csv_list: LIST [STRING]
			csv_values: ARRAY [DOUBLE]; i: INTEGER
		do
--			log.enter_with_args ("csv_double_array_list", << file_name >>)
			Result := create {LINKED_LIST [ARRAY [DOUBLE]]}.make
			from
				create file_in.make_open_read (file_path)
				file_in.read_line
			until
				file_in.last_string.count = 0
			loop
				csv_list := file_in.last_string.split (',')
				create csv_values.make (
					csv_list.i_th (1).to_integer, csv_list.i_th (2).to_integer
				)
				from
					i := csv_values.lower
					csv_list.go_i_th (3)
				until
					i > csv_values.upper
				loop
					csv_values [i] := csv_list.item.to_double
					csv_list.forth
					i := i + 1
				end
				Result.extend (csv_values)
				file_in.read_line
			end
			file_in.close
--			log.exit
		end

	array_double_list_from_file (file_path: EL_FILE_PATH): LIST [ARRAY [DOUBLE]]
			--
		local
			file_in: RAW_FILE; i, lower, upper: INTEGER
			array_doubles: ARRAY [DOUBLE]
		do
--			log.enter_with_args ("array_double_list_from_file", << file_name >>)
--			log.put_path_field ("path", file_path)
--			log.put_new_line

			Result := create {LINKED_LIST [ARRAY [DOUBLE]]}.make
			from
				create file_in.make_open_read (file_path)
			until
				file_in.position = file_in.count
			loop
				file_in.read_integer_32
				lower := file_in.last_integer_32
				file_in.read_integer_32
				upper := file_in.last_integer_32
				create array_doubles.make (lower, upper)
				from i := lower until i > upper loop
					file_in.read_double
					array_doubles [i] := file_in.last_double
					i := i + 1
				end
				Result.extend (array_doubles)
			end
			file_in.close
--			log.exit
		end

end
