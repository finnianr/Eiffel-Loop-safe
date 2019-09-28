note
	description: "Sends an XML string representing a method invocation request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:36:38 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_XML_NETWORK_MESSENGER

inherit
	EL_CONSUMER_THREAD [STRING]
		rename
			consume_product as send_message,
			make as make_consumer,
			product as xml_message
		redefine
			execute
		end

	ASCII
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (port_num: INTEGER)
			--
		do
			make_consumer
			create listen_socket.make_server_by_port (port_num)
		end

feature {NONE} -- Implementation

	send_message
			--
		do
			if is_lio_enabled then
				lio.put_line ("sending message")
			end
			data_socket.put_string (xml_message)
			if is_lio_enabled then
				lio.put_string_field_to_max_length ("XML", xml_message, 80 )
				lio.put_new_line
			end
		rescue
			-- The network connection has probably been broken
			net_exception_occurred := true
		end

	execute
			--
		do
			listen_socket.listen (1)
			listen_socket.accept
			data_socket := listen_socket.accepted
			Precursor
			data_socket.close
			listen_socket.cleanup
		end

	listen_socket, data_socket: NETWORK_STREAM_SOCKET

	net_exception_occurred: BOOLEAN

end



