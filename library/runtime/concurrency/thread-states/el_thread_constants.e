note
	description: "Thread constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_THREAD_CONSTANTS

feature -- States

	State_active: INTEGER = 1

	State_activating: INTEGER = 2

	State_stopped: INTEGER = 3

	State_stopping: INTEGER = 4

	State_consuming: INTEGER = 5

	State_waiting: INTEGER = 6

	State_suspending: INTEGER = 8

	State_interrupted: INTEGER = 9

	State_uninterrupted: INTEGER = 10

feature {NONE} -- Implementation

	Last_state_constant: INTEGER
			--
		do
			Result := State_uninterrupted
		end

end
