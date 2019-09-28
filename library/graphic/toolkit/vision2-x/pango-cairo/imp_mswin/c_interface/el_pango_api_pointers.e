note
	description: "API function pointers for libpango-1.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "2"

class
	EL_PANGO_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	layout_get_indent: POINTER

	layout_get_pixel_size: POINTER

	layout_get_text: POINTER

	layout_get_size: POINTER

	font_description_new: POINTER

	font_description_from_string: POINTER

	layout_set_font_description: POINTER

	font_description_set_absolute_size: POINTER

	layout_set_text: POINTER

	layout_set_width: POINTER

	font_description_set_stretch: POINTER

	font_description_set_family: POINTER

	font_description_set_style: POINTER

	font_description_set_weight: POINTER

	font_description_set_size: POINTER

	font_description_free: POINTER

end
