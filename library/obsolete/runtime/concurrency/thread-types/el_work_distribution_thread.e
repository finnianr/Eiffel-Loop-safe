note
	description: "[
		thread to apply routines distributed by class [$source EL_WORK_DISTRIBUTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-21 17:28:38 GMT (Wednesday 21st June 2017)"
	revision: "6"

class
	EL_WORK_DISTRIBUTION_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD

create
	make

feature {NONE} -- Initialization

	make (a_distributer: like distributer)
		do
			make_default
			distributer := a_distributer
			create mutex.make
		end

feature -- Basic operations

	loop_action
			--
		do
			distributer.wait_to_apply (mutex)
		end

feature {NONE} -- Internal attributes

	distributer: EL_WORK_DISTRIBUTER

	mutex: MUTEX
end
