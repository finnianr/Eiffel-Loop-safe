note
	description: "Remote routine call request handler proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY

inherit
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

	EL_REMOTE_PROXY
		rename
			set_outbound_transmission_type as set_proxy_outbound_transmission_type,
			set_inbound_transmission_type as set_proxy_inbound_transmission_type
		export
			{NONE} all
		end

create
	make

feature -- Basic operations

	set_stopping
			-- Shutdown the current session in the remote routine call request handler
			-- Processing instruction example:
			--		<?call {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}.set_stopping?>
   		do
			log.enter (R_set_stopping)
			call (R_set_stopping, [])
			log.exit
   		end

feature -- Status setting

	set_inbound_transmission_type (type: INTEGER)
			--
		do
			log.enter (R_set_inbound_transmission_type)
			call (R_set_inbound_transmission_type, [type])
			log.exit
		end

	set_outbound_transmission_type (type: INTEGER)
			--
		do
			log.enter (R_set_outbound_transmission_type)
			call (R_set_outbound_transmission_type, [type])
			log.exit
		end

feature {NONE} -- Routine names

	R_set_stopping: STRING = "set_stopping"

	R_set_inbound_transmission_type: STRING = "set_inbound_transmission_type"

	R_set_outbound_transmission_type: STRING = "set_outbound_transmission_type"

end
