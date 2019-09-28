note
	description: "Base class for drawable objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 12:26:47 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_DRAWING_AREA_BASE

inherit
	EV_DRAWING_AREA
		redefine
			draw_text_top_left, draw_text
		end

	EL_DRAWABLE

	EL_MODULE_STRING_32

feature -- Access

	resizeable_cell: EV_CELL
		do
			create Result
			Result.put (Current)
			delay_redraw_until_dimensions_set
		end

feature -- Element change

	set_expose_actions
		do
			expose_actions.extend (agent on_redraw)
		end

feature -- Basic operations

	delay_redraw_until_dimensions_set
		do
			expose_actions.block
			resize_actions.extend (agent on_resize)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
			Precursor (x, y, a_text.to_string_32)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		do
			Precursor (x, y, a_text.to_string_32)
		end

	simulate_pointer_motion
		local
			position: EV_COORDINATE
		do
			position := pointer_position
			pointer_motion_actions.call ([position.x, position.y, 0.0, 0.0, 0.0, screen_x + position.x, screen_y + position.y])
		end

feature {NONE} -- Event handlers

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_height > 1 and a_width > 1 then
				resize (a_width, a_height)
				expose_actions.resume
				redraw
			end
		end

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	resize (a_width, a_height: INTEGER)
			--
		do
			set_minimum_size (a_width, a_height)
		end

end
