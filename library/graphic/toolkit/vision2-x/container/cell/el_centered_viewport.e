note
	description: "Viewport with horizontally centered content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_CENTERED_VIEWPORT

inherit
	EV_VIEWPORT
		redefine
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EV_VIEWPORT}
			resize_actions.extend (agent on_resize)
		end

feature {NONE} -- Event Handling

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		local
			item_width: INTEGER
		do
			if readable and a_width > 0 then
				item.set_minimum_width (width)
				item_width := item.width
				if item_width > a_width then
					set_x_offset ((item_width - a_width) // 2)
				end
			end
		end

end