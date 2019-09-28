note
	description: "Simple server"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:37:13 GMT (Monday 1st July 2019)"
	revision: "7"

class
	EL_SIMPLE_SERVER [H -> EL_SERVER_COMMAND_HANDLER create make end]

inherit
	ANY EL_MODULE_LIO

create
	make_local

feature {NONE} -- Initialization

	make_local (a_port: INTEGER)
		do
			create handler.make
			create socket.make_server_by_port (a_port)
		end

feature -- Basic operations

	do_service_loop
			-- serve one client until quite received
		local
			client: EL_NETWORK_STREAM_SOCKET
			done: BOOLEAN; pos_space: INTEGER; command, message: STRING
		do
			lio.put_line ("launching")
			socket.listen (1)
			lio.put_line ("Waiting for connection")
			socket.accept
			lio.put_line ("accepted")
			from until done loop
				if socket.is_client_connected then
					client := socket.accepted
					if client.is_readable then
						client.read_line
						message := client.last_string
						if message ~ "quit" then
							done := True
						else
							pos_space := message.index_of (' ', 1)
							if pos_space > 0 then
								command := message.substring (1, pos_space - 1)
								handler.execute (command, message.substring (pos_space + 1, message.count))
							else
								handler.execute (message, "")
							end
						end
					end
				end
			end
			socket.cleanup
		end

feature {NONE} -- Implementation

	socket: EL_NETWORK_STREAM_SOCKET

	handler: H

end
