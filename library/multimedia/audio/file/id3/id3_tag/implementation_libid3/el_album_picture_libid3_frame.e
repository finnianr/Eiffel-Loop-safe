note
	description: "Album picture libid3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_ALBUM_PICTURE_LIBID3_FRAME

inherit
	EL_ALBUM_PICTURE_ID3_FRAME
		undefine
			make_from_pointer
		end

	EL_LIBID3_FRAME
		undefine
			set_description, description
		end

	EL_LIBID3_CONSTANTS
		undefine
			out
		end

create
	make, make_from_pointer

feature {NONE} -- Implementation

	Mime_type_index: INTEGER = 3

	Description_index: INTEGER = 5

	Image_index: INTEGER = 6


end