note
	description: "Underbit id3 description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_UNDERBIT_ID3_DESCRIPTION_FIELD

inherit
	EL_UNDERBIT_ID3_ENCODED_FIELD
		redefine
			type
		end

create
	make

feature -- Access

	type: INTEGER
		do
			Result := Type_description
		end
end