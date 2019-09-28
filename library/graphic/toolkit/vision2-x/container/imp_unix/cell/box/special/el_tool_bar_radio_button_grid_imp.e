note
	description: "[
		Warning: this implementation was originally written for Windows and may not work on GTK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_TOOL_BAR_RADIO_BUTTON_GRID_IMP

inherit
	EL_TOOL_BAR_RADIO_BUTTON_GRID_I
		undefine
			-- Not sure if undefining in right class
			propagate_background_color, propagate_foreground_color
		redefine
			interface
		end

	EV_VERTICAL_BOX_IMP
		rename
			radio_group as radio_button_group
		redefine
			interface, make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create radio_group.make
		end

feature {EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP} -- Implementation

	radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP]

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: EL_TOOL_BAR_RADIO_BUTTON_GRID

end