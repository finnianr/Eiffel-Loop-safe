note
	description: "[
		Repeats an action at timed intervals and prompts any registered responder
		May work but not fully tested.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "3"

deferred class
	EL_RHYTHMIC_ACTION_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		redefine
			execute_thread
		end

feature {NONE} -- Initialization

	make (interval_millisecs: INTEGER)
			-- make with milliscec interval
		do
			make_default
			interval := interval_millisecs
			set_stopped
		end

feature -- Element change

	set_interval (an_interval: INTEGER)
			-- Assign `an_interval' in milliseconds to `interval'.
			-- If `an_interval' is 0, `actions' are disabled.
		do
			interval := an_interval
		end

feature {NONE} -- Implementation

	execute_thread
			-- Continuous loop to do action
		do
			set_active
			from until is_stopping loop
				loop_action
				if not is_stopping then
					sleep (interval)
				end
			end
			set_stopped
		end

	interval: INTEGER
		-- Time interval in millisecs

end
