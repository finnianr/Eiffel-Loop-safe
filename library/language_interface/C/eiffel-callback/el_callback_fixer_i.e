note
	description: "[
		Fixes an Eiffel object in memory so that it can be the target of callbacks from a
		C routine. The garbage collector is prevented from moving it during collect cycles.
	]"
	instructions: "[
		Use this class by making a call to the `new_callback' function in a descendant of class
		[$source EL_C_CALLABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "4"

deferred class
	EL_CALLBACK_FIXER_I

inherit
	EL_CALLBACK_C_API

	EL_MEMORY

feature {NONE} -- Initialization

	make (target: EL_C_CALLABLE)
			--
		deferred
		end

feature -- Access

	item: POINTER
		-- pointer to object fixed in memory

feature {NONE} -- Implementation

	set_item (target: EL_C_CALLABLE)
		do
			item := c_eif_freeze (target)
			target.set_fixed_address (item)
		end

feature -- Status change

	release
		do
			c_eif_unfreeze (item); item := Default_pointer
		end

end

