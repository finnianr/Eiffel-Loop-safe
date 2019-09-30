note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for reference field attribute types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	HASH_TABLE [G, STRING]
		rename
			make as make_with_count,
			make_equal as make
		redefine
			make
		end

	EL_REFERENCE_FIELD_VALUE_TABLE_HELPER [G]
		redefine
			make
		end

create
	make,
	make_with_count

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor {HASH_TABLE} (n)
			Precursor {EL_REFERENCE_FIELD_VALUE_TABLE_HELPER} (n)
		end

end
