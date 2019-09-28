note
	description: "Logged identified thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_LOGGED_IDENTIFIED_THREAD

inherit
	EL_IDENTIFIED_THREAD
		redefine
			on_start
		end

	EL_MODULE_LOG_MANAGER

	EL_MODULE_LOG

feature -- Basic operations

	log_stopping
		local
			l_count, checks_per_2_secs: INTEGER
		do
			checks_per_2_secs := (2000 / Check_stopped_interval_ms).rounded
			from until is_stopped loop
				sleep (Check_stopped_interval_ms)
				l_count := l_count + 1
				if l_count \\  checks_per_2_secs = 0 then
					lio.put_labeled_string ("Stopping", name)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Event handling

	on_start
		do
			Log_manager.add_thread (Current)
		end

feature {NONE} -- Constants

	Check_stopped_interval_ms: INTEGER
			-- milliseconds between checking if thread is stopped
		once
			Result := 100
		end

end
