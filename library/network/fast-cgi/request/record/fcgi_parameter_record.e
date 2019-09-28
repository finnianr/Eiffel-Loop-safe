note
	description: "[
		`FCGI_PARAMS' is a stream record type used in sending name-value pairs from the Web server
		to the application. The name-value pairs are sent down the stream one after the other,
		in no specified order.
		
		See: [https://fast-cgi.github.io/spec#52-name-value-pair-streams-fcgi_params]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:04:32 GMT (Monday 1st July 2019)"
	revision: "5"

class
	FCGI_PARAMETER_RECORD

inherit
	FCGI_STRING_CONTENT_RECORD
		rename
			content as name,
			read_content as read_name
		redefine
			default_create, read_memory, write_memory, on_data_read, on_last_read
		end

	EL_SHARED_ONCE_STRINGS

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor {FCGI_STRING_CONTENT_RECORD}
			create value.make_empty
		end

feature -- Access

	value: ZSTRING

feature {NONE} -- Implementation

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		local
			name_count, value_count: INTEGER
			utf_8_str: STRING
		do
			name_count := memory.parameter_length
			value_count := memory.parameter_length
			read_name (memory, name_count)

			utf_8_str := empty_once_string_8
			memory.read_to_string_8 (utf_8_str, value_count)
			value.wipe_out
			value.append_utf_8 (utf_8_str)
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
		end

	on_data_read (broker: FCGI_REQUEST_BROKER)
		do
			broker.on_parameter (Current)
		end

	on_last_read (broker: FCGI_REQUEST_BROKER)
		do
			broker.on_parameter_last
		end

end
