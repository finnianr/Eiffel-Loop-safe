note
	description: "[
		A FastCGI record consists of a fixed-length prefix followed by a variable number of content and padding bytes.
		See: [https://fast-cgi.github.io/spec#33-records]
		
			typedef struct {
				unsigned char version;
				unsigned char type;
				unsigned char requestIdB1;
				unsigned char requestIdB0;
				unsigned char contentLengthB1;
				unsigned char contentLengthB0;
				unsigned char paddingLength;
				unsigned char reserved;
				unsigned char contentData[contentLength];
				unsigned char paddingData[paddingLength];
			} FCGI_Record;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-03 16:57:50 GMT (Saturday 3rd March 2018)"
	revision: "6"

class
	FCGI_HEADER_RECORD

inherit
	FCGI_RECORD

feature -- Element change

	set_fields (a_version: NATURAL_8; a_request_id: NATURAL_16; a_type, a_content_length, a_padding_length: INTEGER)
			-- Create a new record header for the specified request.	
		require
			valid_version: a_version >= 1
			valid_request_id: a_request_id >= 0
			-- valid_type: valid_type (a_type)
			valid_content_length: a_content_length >= 0
			valid_padding_length: a_padding_length >= 0
		do
			version := a_version
			type := a_type.to_natural_8

			request_id := a_request_id
			content_length := a_content_length.to_natural_16
			padding_length := a_padding_length.to_natural_8
		end

feature -- Access

	content_length: NATURAL_16

	padding_length: NATURAL_8

	request_id: NATURAL_16

	type: NATURAL_8

	type_record: FCGI_RECORD
		do
			Result := Record_type_array [type]
		end

	version: NATURAL_8

feature -- Status query

	is_aborted: BOOLEAN
		-- `True' if type is signal to abort request
		do
			Result := type = Fcgi_abort_request
		end

	is_empty: BOOLEAN
		do
			Result := content_length = 0
		end

	is_end_service: BOOLEAN
		-- `True' if type is request to end service
		do
			Result := type = Fcgi_end_service
		end

	is_stdout: BOOLEAN
		-- `True' if type is request to write to stdout
		do
			Result := type = Fcgi_stdout
		end

feature -- Element change

	set_byte_count (a_byte_count: like byte_count)
		do
			byte_count := a_byte_count
		end
	
feature {NONE} -- Implementation

	on_data_read (request: FCGI_REQUEST_BROKER)
		do
			request.on_header (Current)
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			version := memory.read_natural_8
			type := memory.read_natural_8
			request_id := memory.read_natural_16
			content_length := memory.read_natural_16
			padding_length := memory.read_natural_8
		ensure then
			same_request_id: request_id = Fcgi_default_request_id
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			 memory.write_natural_8 (version)
			 memory.write_natural_8 (type)
			 memory.write_natural_16 (request_id)
			 memory.write_natural_16 (content_length)
			 memory.write_natural_8 (padding_length)
		end

feature {NONE} -- Constants

	Record_type_array: ARRAY [FCGI_RECORD]
		local
			content: FCGI_STRING_CONTENT_RECORD
		once
			create content
			create Result.make_filled (content, 1, Fcgi_stdout)
			Result [Fcgi_params] := create {FCGI_PARAMETER_RECORD}
			Result [Fcgi_begin_request] := create {FCGI_BEGIN_REQUEST_RECORD}
			Result [Fcgi_end_request] := create {FCGI_END_REQUEST_RECORD}
			Result [Fcgi_stdin] := content
			Result [Fcgi_stdout] := content
		end

feature {NONE} -- Constants

	Reserved_count: INTEGER = 1

end
