note
	description: "Object to query command line arguments. Accessible via [$source EL_MODULE_ARGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:46:51 GMT (Friday 25th January 2019)"
	revision: "7"

class
	EL_COMMAND_LINE_ARGUMENTS

inherit
	ARGUMENTS_32
		redefine
			index_of_word_option, index_of_beginning_with_word_option, separate_word_option_value
		end

	EL_MODULE_STRING_32

feature -- Access

	remaining_items (index: INTEGER): ARRAYED_LIST [ZSTRING]
		require
			valid_index: index <= argument_count
		local
			i: INTEGER
		do
			create Result.make (argument_count - index + 1)
			from i := index until i > argument_count loop
				Result.extend (item (i))
				i := i + 1
			end
		end

	remaining_file_paths (index: INTEGER): ARRAYED_LIST [EL_FILE_PATH]
		require
			valid_index: index <= argument_count
		local
			l_remaining_items: like remaining_items
		do
			l_remaining_items := remaining_items (index)
			create Result.make (l_remaining_items.count)
			across l_remaining_items as string loop
				Result.extend (string.item)
			end
		end

	item (i: INTEGER): ZSTRING
		require
			item_exists: 1 <= i and i <= argument_count
		do
			create Result.make_from_general (argument (i))
		end

	directory_path (name: READABLE_STRING_GENERAL): EL_DIR_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	file_path (name: READABLE_STRING_GENERAL): EL_FILE_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	integer (name: READABLE_STRING_GENERAL): INTEGER
		require
			integer_value_exists: has_integer (name)
		do
			Result := value (name).to_integer
		end

	option_name (index: INTEGER): ZSTRING
		do
			if argument_array.valid_index (index) then
				Result := item (index)
				Result.prune_all_leading ('-')
			else
				create Result.make_empty
			end
		end

	value (name: READABLE_STRING_GENERAL): ZSTRING
			-- string value of name value pair arguments
		require
			has_value: has_value (name)
		local
			index: INTEGER
		do
			index := index_of_word_option (name) + 1
			if index >= 2 and index <= argument_count then
				Result := item (index)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	set_string_from_word_option (
		word_option: READABLE_STRING_GENERAL; set_string: PROCEDURE [ZSTRING]; default_value: ZSTRING
	)
			--
		do
			if has_value (word_option) then
				set_string (item (index_of_word_option (word_option) + 1))
			else
				set_string (default_value)
			end
		end

	set_real_from_word_option (word_option: READABLE_STRING_GENERAL; set_real: PROCEDURE [REAL]; default_value: REAL)
			--
		local
			real_string: ZSTRING
		do
			if has_value (word_option) then
				real_string := item (index_of_word_option (word_option) + 1)
				if real_string.is_real then
					set_real (real_string.to_real)
				end
			else
				set_real (default_value)
			end
		end

	set_integer_from_word_option (
		word_option: READABLE_STRING_GENERAL; set_integer: PROCEDURE [INTEGER]; default_value: INTEGER
	)
			--
		local
			integer_string: ZSTRING
		do
			if has_value (word_option) then
				integer_string := item (index_of_word_option (word_option) + 1)
				if integer_string.is_integer then
					set_integer (integer_string.to_integer)
				end
			else
				set_integer (default_value)
			end
		end

	set_boolean_from_word_option (word_option: READABLE_STRING_GENERAL; set_boolean: PROCEDURE)
			--
		do
			if word_option_exists (word_option) then
				set_boolean.apply
			end
		end

feature -- Status query

	has_integer (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_value (name) and then value (name).is_integer
		end

	has_value (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := index_of_beginning_with_word_option (name) > 0
		end

	has_silent: BOOLEAN
		do
			Result := word_option_exists ({EL_COMMAND_OPTIONS}.Silent)
		end

	has_no_app_header: BOOLEAN
		do
			Result := word_option_exists ({EL_COMMAND_OPTIONS}.No_app_header)
		end

	word_option_exists (word_option: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := index_of_word_option (word_option) > 0
		end

	character_option_exists (character_option: CHARACTER_32): BOOLEAN
			--
		do
			Result := index_of_character_option (character_option) > 0
		end

feature -- ZSTRING conversion

	index_of_word_option (opt: READABLE_STRING_GENERAL): INTEGER
		 -- Converts ZSTRING objects
		do
			Result := Precursor (opt.to_string_32)
		end

	index_of_beginning_with_word_option (opt: READABLE_STRING_GENERAL): INTEGER
		 -- Converts ZSTRING objects
		do
			Result := Precursor (opt.to_string_32)
		end

	separate_word_option_value (opt: READABLE_STRING_GENERAL): IMMUTABLE_STRING_32
		 -- Converts ZSTRING objects
		do
			Result := Precursor (opt.to_string_32)
			check has_result: attached Result end
		end

end
