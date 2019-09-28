note
	description: "HTML viewer navigation link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-11 13:30:34 GMT (Friday 11th January 2019)"
	revision: "1"

class
	EL_HTML_TEXT_HYPERLINK_AREA

inherit
	EL_HYPERLINK_AREA
		rename
			make as make_link
		end

create
	make

feature {NONE} -- Initialization

	make (html_text: EL_HTML_TEXT; header: EL_FORMATTED_TEXT_HEADER)
		do
			level := header.level
			make_link (
				header.text, agent html_text.scroll_to_heading_line (header.interval.lower),
				html_text.content_heading_font (header), GUI.text_field_background_color
			)
		end

feature -- Access

	level: INTEGER
end
