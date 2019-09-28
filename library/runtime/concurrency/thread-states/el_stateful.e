note
	description: "Stateful"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_STATEFUL

feature -- Initialization

	make_default
			--
		do
			create actual_state
		end

feature -- Access

	state: INTEGER
			--
		do
			Result := actual_state.value
		end

feature -- Element change

	set_state (a_state: INTEGER)
			--
		do
			actual_state.set_value (a_state)
		end

feature {NONE} -- Implementation

	actual_state: EL_MUTEX_NUMERIC [INTEGER]

end
