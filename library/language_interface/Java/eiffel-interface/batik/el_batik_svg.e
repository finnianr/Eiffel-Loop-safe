note
	description: "Batik svg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_BATIK_SVG

feature -- Basic operations

	convert_svg_to_png (svg_file_path, png_file_path: EL_FILE_PATH; width, background_color_as_24_bit_rgb: INTEGER)
		local
			transcoder: J_SVG_TO_PNG_TRANSCODER
		do
			create transcoder.make
			transcoder.set_width (width)
			transcoder.set_background_color_with_24_bit_rgb (background_color_as_24_bit_rgb)
			transcoder.transcode (svg_file_path.to_string, png_file_path.to_string)
		end

end
