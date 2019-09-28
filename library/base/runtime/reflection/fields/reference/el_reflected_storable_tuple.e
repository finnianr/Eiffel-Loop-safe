note
	description: "Reflected TUPLE that can be read and written to an object of type [$source EL_MEMORY_READER_WRITER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 16:22:45 GMT (Tuesday 10th September 2019)"
	revision: "11"

class
	EL_REFLECTED_STORABLE_TUPLE

inherit
	EL_REFLECTED_TUPLE
		undefine
			set_from_readable
		redefine
			write
		end

	EL_REFLECTED_READABLE [TUPLE]
		undefine
			is_initializeable,
			make, initialize, new_instance, reset, set_from_string, to_string
		redefine
			write
		end

create
	make

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		do
			read_tuple (value (a_object), reader)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			write_tuple (value (a_object), writeable, Empty_string_8)
		end

feature {NONE} -- Implementation

	read_tuple (tuple: TUPLE; reader: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						tuple.put_character (reader.read_character_8, i)

					when {TUPLE}.Character_32_code then
						tuple.put_character_32 (reader.read_character_32, i)

					when {TUPLE}.Boolean_code then
						tuple.put_boolean (reader.read_boolean, i)

					when {TUPLE}.Integer_8_code then
						tuple.put_integer_8 (reader.read_integer_8, i)

					when {TUPLE}.Integer_16_code then
						tuple.put_integer_16 (reader.read_integer_16, i)

					when {TUPLE}.Integer_32_code then
						tuple.put_integer (reader.read_integer_32, i)

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (reader.read_integer_64, i)

					when {TUPLE}.Natural_8_code then
						tuple.put_natural_8 (reader.read_natural_8, i)

					when {TUPLE}.Natural_16_code then
						tuple.put_natural_16 (reader.read_natural_16, i)

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (reader.read_natural_32, i)

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (reader.read_natural_64, i)

					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (reader.read_real_32, i)

					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (reader.read_real_64, i)

					when {TUPLE}.Reference_code then
						if attached {STRING_GENERAL} tuple.reference_item (i) as str then
							if attached {ZSTRING} str then
								tuple.put_reference (reader.read_string, i)
							elseif attached {STRING} str then
								tuple.put_reference (reader.read_string_8, i)
							elseif attached {STRING_32} str then
								tuple.put_reference (reader.read_string_32, i)
							end
						end
				else
				end
				i := i + 1
			end
		end

end
