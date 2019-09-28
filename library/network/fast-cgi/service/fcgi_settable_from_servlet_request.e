note
	description: "[
		Object that is reflectively settable from `{[$source FCGI_SERVLET_REQUEST]}.method_parameters'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:12:59 GMT (Monday 23rd April 2018)"
	revision: "2"

deferred class
	FCGI_SETTABLE_FROM_SERVLET_REQUEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		end

	EL_SETTABLE_FROM_ZSTRING

feature {NONE} -- Initialization

	make (request: FCGI_SERVLET_REQUEST)
		do
			make_default
			set_from_request (request)
		end

feature -- Element change

	set_from_request (request: FCGI_SERVLET_REQUEST)
		do
			set_from_zkey_table (request.method_parameters)
		end

end
