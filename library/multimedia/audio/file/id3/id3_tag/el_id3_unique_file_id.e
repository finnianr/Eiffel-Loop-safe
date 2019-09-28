note
	description: "Id3 unique file id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:15:10 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_ID3_UNIQUE_FILE_ID

inherit
	EL_ID3_FRAME
		rename
			code as field_id
		end

	EL_ID3_ENCODINGS
		undefine
			out
		end

	EL_MODULE_TAG

feature {NONE} -- Initialization

	make (owner_id: like owner; an_id: like id)
			--
		do
			make_with_code (Tag.Unique_file_ID)
			set_owner (owner_id)
			set_id (an_id)
		end

feature -- Access

	owner: ZSTRING
			--
		require
			valid_field_id: has_owner_field
		do
        	Result := string_of_type (Type_string_data)
		end

	id: STRING
			-- unique id
		require
			valid_field_id: has_data_field
		do
			Result := data_string
		end

feature -- Status query

	has_owner_field: BOOLEAN
		do
			Result := index_of_type (Type_string_data) > 0
		end

	has_data_field: BOOLEAN
		do
			Result := index_of_type (Type_binary_data) > 0
		end

feature -- Element change

	set_owner (owner_id: ZSTRING)
			--
		require
			valid_field_id: has_owner_field
		do
			set_string_of_type (Type_string_data, owner_id)
		end

	set_id (an_id: STRING)
			--
		require
			valid_field_id: has_data_field
		do
			set_data_string (an_id)
		end

end
