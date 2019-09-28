note
	description: "Remote routine call request handling thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD

inherit
	EL_LOGGED_MANY_TO_ONE_CONSUMER_THREAD [EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET]
		rename
			product as client_socket,
			consume_product as serve_client
		redefine
			launch, stop
		end

create
	make

feature -- Element change

	set_log_name_suffix (suffix: INTEGER)
			--
		do
			set_name (Log_name_root + suffix.out)
		end

	set_client_request_handler (a_client_request_handler: like client_request_handler)
			--
		do
			client_request_handler := a_client_request_handler
			is_client_request_handler_set := true
		end

	set_routine_call_event_listener (a_routine_call_event_listener: like routine_call_event_listener)
			--
		do
			routine_call_event_listener := a_routine_call_event_listener
			client_request_handler.set_listener (routine_call_event_listener)
		end

feature -- Basic operations

	launch
			--
		require else
			client_request_handler_not_void: is_client_request_handler_set
		do
			Precursor
		end

	stop
			--
		do
			client_request_handler.stop
			Precursor
		end

feature -- Status query

	is_client_request_handler_set: BOOLEAN

feature {NONE} -- Implementation

	serve_client
			--
		do
			log.enter ("serve_client")
			client_request_handler.serve (client_socket)
			routine_call_event_listener.remove_connection
			log.exit
		end

	client_request_handler: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER

	routine_call_event_listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER

feature {NONE} -- Constants

	Is_visible_in_console: BOOLEAN = true

	Log_name_root: ZSTRING
		once
			Result := "Client request handler "
		end

end