note
	description: "Base class for [$source EL_ENCODEABLE_AS_TEXT] and [$source EL_ENCODING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 14:35:35 GMT (Tuesday 10th April 2018)"
	revision: "1"

class
	EL_ENCODING_BASE

feature {NONE} -- Initialization

	make_default
		do
			set_default
		end

	make_latin_1
		do
			set_latin (1)
		end

	make_utf_8
		do
			set_utf (8)
		end

feature -- Access

	id: INTEGER
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Type_utf' these are: {8, 16, 32}
		-- For `Type_latin' these are: 1..16
		-- For `Type_windows' these are: 1250..1258
		do
			Result := internal_encoding & Type_mask
		end

	name: STRING
			--
		do
			create Result.make (12)
			if internal_encoding = 0 then
				Result.append (once "Unknown")
			else
				inspect type
					when Type_utf then
						Result.append (Name_utf)
					when Type_windows then
						Result.append (Name_windows)
					when Type_latin then
						Result.append (Name_iso)
						Result.append_character ('-')
						Result.append_integer (8859)
				else
				end
				Result.append_character ('-')
				Result.append_integer (id)
			end
		end

	type: INTEGER
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := internal_encoding & ID_mask
		end

feature -- Status query

	is_valid (a_type, a_id: INTEGER): BOOLEAN
		do
			check attached Valid_id_sets.item (a_type) as al_item then
				Result := Valid_types.has (a_type) and then al_item.has (a_id)
			end
		end

feature -- Status query

	is_latin_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_latin, a_id)
		do
			Result := internal_encoding = Type_latin | a_id
		end

	is_type_latin: BOOLEAN
		do
			Result := type = Type_latin
		end

	is_type_utf: BOOLEAN
		do
			Result := type = Type_utf
		end

	is_type_windows: BOOLEAN
		do
			Result := type = Type_windows
		end

	is_utf_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_utf, a_id)
		do
			Result := internal_encoding = Type_utf | a_id
		end

	is_windows_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_windows, a_id)
		do
			Result := internal_encoding = Type_windows | a_id
		end

	same_as (other: EL_ENCODING_BASE): BOOLEAN
		do
			Result := internal_encoding = other.internal_encoding
		end

feature -- Element change

	set_encoding (a_type, a_id: INTEGER)
			--
		require
			valid_type_and_id: is_valid (a_type, a_id)
		do
			internal_encoding := a_type | a_id
		ensure
			type_set: type = a_type
			id_set: id = a_id
		end

	set_from_name (a_name: READABLE_STRING_GENERAL)
			--
		local
			parts: EL_SPLIT_STRING_LIST [STRING]
			part: STRING; l_type, l_id: INTEGER
		do
			create parts.make (a_name.to_string_8, once "-")
			from parts.start until parts.after loop
				part := parts.item
				if parts.index = 1 then
					part.to_upper
					if part ~ Name_iso then
						parts.forth
						if not parts.after and then parts.item.to_integer = 8859 then
							l_type := Type_latin
						end
					elseif part ~ Name_windows then
						l_type := Type_windows
					elseif part ~ Name_utf then
						l_type := Type_utf
					end
				else
					l_id := parts.item.to_integer
				end
				parts.forth
			end
			if is_valid (l_type, l_id) then
				set_encoding (l_type, l_id)
			else
				internal_encoding := 0
			end
		ensure
			reversible: internal_encoding > 0 implies a_name.to_string_8.as_upper ~ name
		end

	set_from_other (other: EL_ENCODING_BASE)
		do
			set_encoding (other.type, other.id)
		ensure
			same_encoding: internal_encoding = other.internal_encoding
		end

	set_default
		do
			set_utf (8)
		end

	set_latin, set_iso_8859 (a_id: INTEGER)
		do
			set_encoding (Type_latin, a_id)
		end

	set_utf (a_id: INTEGER)
		do
			set_encoding (Type_utf, a_id)
		end

	set_windows (a_id: INTEGER)
		do
			set_encoding (Type_windows, a_id)
		end

feature {EL_ENCODING_BASE} -- Internal attributes

	internal_encoding: INTEGER
		-- bitwise OR of `type' and `id'

feature -- Encoding types

	Type_latin: INTEGER = 0x1000

	Type_utf: INTEGER = 0x3000

	Type_windows: INTEGER = 0x2000

	Valid_types: ARRAY [INTEGER]
		once
			Result := Valid_id_sets.current_keys
		end

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

feature {NONE} -- Constants

	ID_mask: INTEGER = 0xF000
		-- masks out the `id' from `internal_encoding'

	Type_mask: INTEGER = 0xFFF
		-- masks out the `type' from `internal_encoding'

	Valid_id_sets: HASH_TABLE [SET [INTEGER], INTEGER]
		local
			utf_encodings: ARRAYED_SET [INTEGER]
		once
			create Result.make_equal (3)
			create utf_encodings.make (3)
			across << 8, 16, 32 >> as bytes loop utf_encodings.put (bytes.item) end
			Result [Type_utf] := utf_encodings

			Result [Type_latin] := 1 |..| 16
			Result [Type_windows] := 1250 |..| 1258
		end

end
