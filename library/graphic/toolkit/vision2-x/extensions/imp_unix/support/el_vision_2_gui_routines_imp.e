note
	description: "Unix implementation of [$source EL_VISION_2_GUI_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_VISION_2_GUI_ROUTINES_IMP

inherit
	EL_VISION_2_GUI_ROUTINES_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	Text_field_background_color: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end
