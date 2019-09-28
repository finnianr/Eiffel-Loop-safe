note
	description: "Drawable label"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-20 13:49:34 GMT (Monday 20th May 2019)"
	revision: "7"

deferred class
	EL_DRAWABLE_LABEL

inherit
	EL_DRAWABLE

	EL_WORD_WRAPPABLE

	EL_SHARED_ONCE_STRINGS

	EL_STRING_8_CONSTANTS

	EL_MODULE_COLOR

feature {NONE} -- Initialization

	make_default
		do
			make_with_text_and_font (Empty_string_8, create {like font})
		end

	make_with_text_and_font (a_text: like text; a_font: like font)
			--
		do
			default_create
			tile_pixmap := Default_pixmap; pixmap := Default_pixmap
			text := a_text
			align_text_left; align_text_center
			set_font_and_height (a_font)
			set_foreground_color (Color.Black)
		end

feature -- Access

	tile_pixmap: EV_PIXMAP

	pixmap: EV_PIXMAP

	text: READABLE_STRING_GENERAL

feature -- Status query

	is_word_wrapped: BOOLEAN

feature -- Status change

	enable_word_wrapping
		do
			is_word_wrapped := True
		end

	disable_word_wrapping
		do
			is_word_wrapped := False
		end

feature -- Element change

	set_pixmap (a_pixmap: like pixmap)
			--
		do
			pixmap := a_pixmap
		end

	set_tile_pixmap (a_tile_pixmap: like tile_pixmap)
			--
		do
			tile_pixmap := a_tile_pixmap
		end

	set_text (a_text: like text)
			--
		do
			text := a_text
			redraw
		end

	set_font_and_height (a_font: EV_FONT)
		do
			set_font (a_font)
			set_minimum_height ((font.line_height * 1.5).rounded)
--			set_minimum_size (font.string_width (text) + font.maximum_width * 2, (font.line_height * 1.5).rounded)
		end

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		local
			l_text: ZSTRING
		do
			clear; draw_background
			create l_text.make_from_general (text)
			if is_word_wrapped then
				new_wrapped_text_rectangle (l_text).draw (Current)
			else
				new_text_rectangle (l_text).draw (Current)
			end
		end

	draw_background
		local
			r: EV_RECTANGLE
		do
			if pixmap /= Default_pixmap then
				draw_pixmap (0 , 0, pixmap)

			elseif tile_pixmap /= Default_pixmap then
				create r.make (0, 0, width, height)
				draw_row_of_tiles (r, tile_pixmap)
				draw_rectangle_shadows (r.x, r.y, r.width, r.height)
			end
		end

	set_minimum_height (a_height: INTEGER)
		deferred
		end

feature {NONE} -- Constants

	Default_pixmap: EL_PIXMAP
		once
			create Result
		end
end
