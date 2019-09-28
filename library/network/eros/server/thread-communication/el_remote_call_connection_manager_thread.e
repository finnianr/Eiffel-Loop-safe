note
	description: "Remote call connection manager thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:40:25 GMT (Monday 1st July 2019)"
	revision: "6"

class
	EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		rename
			loop_action as poll_for_requests
		redefine
			execute, on_start
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

create
	make

feature {NONE} -- Initialization

	make (
		a_port_number, request_handler_count_max: INTEGER
		a_routine_call_event_listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER
	)
			--
		do
			make_default
			set_name ("Connection manager")
			port_number := a_port_number
			create logarithmic_polling_rates.make (5)
			(2 |..| 6).do_all (
				agent (indice: INTEGER)
					do
						logarithmic_polling_rates.extend ((2 ^ indice).rounded)
					end
			)
			logarithmic_polling_rates.start
			create client_connection_queue.make (request_handler_count_max, a_routine_call_event_listener)
		end

feature {NONE} -- Event handling

	on_start
		do
			Log_manager.add_thread (Current)
		end

feature {NONE} -- Implementation

	execute
			--
		do
			log.enter ("execute_thread")
			create connecting_socket.make_server_by_port (port_number)
			connecting_socket.listen (client_connection_queue.request_thread_count_max)
			connecting_socket.set_non_blocking
			client_connection_queue.launch

			log.put_line ("Waiting for connection ..")
			Precursor
			client_connection_queue.delegator.stop
			connecting_socket.close_socket
			log.exit
		end

	poll_for_requests
			--
		local
			polls_per_second: INTEGER
		do
			connecting_socket.accept
			if connecting_socket.is_client_connected then
				lio.put_line ("Connection accepted")
				client_connection_queue.put (connecting_socket.accepted)
				log.put_line ("Waiting for connection ..")
				if not logarithmic_polling_rates.islast then
					logarithmic_polling_rates.forth
				end

			elseif not logarithmic_polling_rates.isfirst then
				logarithmic_polling_rates.back
			end
			polls_per_second := logarithmic_polling_rates.item
			sleep (1000 // polls_per_second)
		end

feature {NONE} -- Internal attributes

	client_connection_queue: EL_REMOTE_CALL_CLIENT_CONNECTION_QUEUE

	connecting_socket: EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET

	logarithmic_polling_rates: ARRAYED_LIST [INTEGER]

	port_number: INTEGER

feature {NONE} -- Constants

	Is_visible_in_console: BOOLEAN = true

end
