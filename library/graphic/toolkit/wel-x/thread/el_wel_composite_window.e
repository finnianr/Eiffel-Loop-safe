note
	description: "[
		Implementation of [$source EL_MAIN_THREAD_EVENT_REQUEST_QUEUE]
		for calling procedures from main application thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_WEL_COMPOSITE_WINDOW

inherit
	WEL_COMPOSITE_WINDOW
		undefine
			destroy, process_message, on_wm_menu_command, on_wm_control_id_command
		redefine
			default_process_message
		end

	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE
		rename
			put as put_event_request
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	default_process_message (msg: INTEGER; wparam, lparam: POINTER)
			-- Process `msg' which has not been processed by
		do
			if msg = Wm_generic_event then
				on_event (wparam.to_integer_32)
			else
				Precursor (msg, wparam, lparam)
			end
		end

	generate_event (index: INTEGER)
			--
		do
			cwin_post_message (item, Wm_generic_event, to_wparam (index), to_lparam (0))
--			{WEL_API}.post_message (item, Wm_generic_event, to_wparam (index), to_lparam (0))
		end

feature {NONE} -- Constants

	Wm_generic_event: INTEGER
			--
		once
			Result := Wm_app + 1
		end

end
