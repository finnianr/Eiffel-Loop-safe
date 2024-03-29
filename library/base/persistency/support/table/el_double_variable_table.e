note
	description: "Double variable table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 11:52:54 GMT (Monday 17th December 2018)"
	revision: "5"

class
	EL_DOUBLE_VARIABLE_TABLE

inherit
	HASH_TABLE [DOUBLE, STRING]

	EL_VARIABLE_TABLE [DOUBLE]
		undefine
			is_equal,
			copy
		end

create
	make,
	make_from_file

feature {NONE} -- Initialization

	make_from_file (file_path: EL_FILE_PATH)
			--
		local
			file_in: PLAIN_TEXT_FILE; variable: STRING
		do
			make (7)
			from
				create file_in.make_open_read (file_path)
				file_in.read_word
			until
				file_in.last_string.count = 0
			loop
				variable := file_in.last_string.out
				file_in.read_word
				put (value_from_string (file_in.last_string), variable)
				file_in.read_word
			end
			file_in.close
		end

feature -- Status query

	has_variable_with_value (variable: STRING; value: DOUBLE): BOOLEAN
			--
		require else
			has_variable: has (variable)
		do
			if value = item (variable) then
				Result := true
			else
				variable_not_found (variable, value)
			end
		end

feature {NONE} -- Implementation

	value_from_string (string: STRING): DOUBLE
			--
		do
			Result := string.to_double
		end

	variable_not_found (variable: STRING; value: DOUBLE)
			--
		do
--			log.enter_with_args ("variable_not_found", << variable >>)
--			log.put_line ("NOT same value")
--			log.put_string ("value: ")
--			log.put_double (value)
--			log.put_new_line
--			log.put_string ("Table value: ")
--			log.put_double (item (variable))
--			log.put_new_line
--			log.exit
		end

end
