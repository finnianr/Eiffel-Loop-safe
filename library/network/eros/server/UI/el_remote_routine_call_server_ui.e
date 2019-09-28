note
	description: "Remote routine call server ui"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_REMOTE_ROUTINE_CALL_SERVER_UI

inherit
	EL_VISION2_USER_INTERFACE [EL_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW]
		rename
			make as make_ui
		redefine
			prepare_to_show
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_port_number, a_request_handler_count_max: INTEGER)
		do
			name := a_name; port_number := a_port_number; request_handler_count_max := a_request_handler_count_max
			make_ui (True)
		end

feature {NONE} -- Implementation

	prepare_to_show
			--
		do
			main_window.set_title (window_title)
			main_window.set_connection_manager (port_number, request_handler_count_max)
			main_window.prepare_to_show
		end

	window_title: STRING
			--
		do
			Result := "Server Monitor [" + name + "]"
		end

	name: STRING

	port_number, request_handler_count_max: INTEGER

feature {NONE} -- Constants

	SVG_pixmaps: ARRAY [EL_SVG_PIXMAP]
			--
		once
			create Result.make_empty
		end

end