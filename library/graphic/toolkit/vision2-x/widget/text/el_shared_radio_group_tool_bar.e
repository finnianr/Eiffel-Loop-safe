note
	description: "Shared radio group tool bar"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:36:45 GMT (Friday 21st December 2018)"
	revision: "5"

class
	EL_SHARED_RADIO_GROUP_TOOL_BAR

inherit
	EV_TOOL_BAR
		redefine
			create_implementation, implementation
		end

create
	make

feature -- 	Initialization

	make (a_radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP])
			--
		do
			radio_group := a_radio_group
			default_create
		end


feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_SHARED_RADIO_GROUP_TOOL_BAR_I
			-- Responsible for interaction with native graphics toolkit.

feature {EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP} implementation.make
		end

	radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP]

end