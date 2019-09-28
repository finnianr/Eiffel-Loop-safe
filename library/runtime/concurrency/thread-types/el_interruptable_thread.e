note
	description: "Interruptable thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_INTERRUPTABLE_THREAD

inherit
	EL_STATEFUL

	EL_THREAD_DEVELOPER_CLASS

feature -- Basic operations

	interrupt
			--
		do
			set_state (State_interrupted)
		end

	set_uninterrupted
			--
		do
			set_state (State_uninterrupted)
		end

feature -- Query status

	is_interrupted: BOOLEAN
			--
		do
			Result := state = State_interrupted
		end

feature {NONE} -- Constants

	State_interrupted: INTEGER
			--
		deferred
		end

	State_uninterrupted: INTEGER
			--
		deferred
		end

end