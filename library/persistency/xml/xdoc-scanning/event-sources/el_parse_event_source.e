note
	description: "Parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 10:01:25 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_PARSE_EVENT_SOURCE

inherit
	EL_ENCODEABLE_AS_TEXT

	EL_XML_NODE_CLIENT

feature {EL_FACTORY_CLIENT} -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			make_default
			scanner := a_scanner

			last_node := scanner.last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
		end

feature -- Access

	xml_version: REAL

feature -- Status query

	has_error: BOOLEAN
		do
		end

feature -- Factory

	new_file_stream (a_file_path: EL_FILE_PATH): FILE
		do
			create {PLAIN_TEXT_FILE} Result.make_with_name (a_file_path)
		ensure
			is_closed: Result.is_closed
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		deferred
		end

	parse_from_string (a_string: STRING)
			-- Parse XML document from `a_string'.
		deferred
		end

	log_error (a_log: EL_LOGGABLE)
		do
		end

feature {EL_XML_DOCUMENT_SCANNER} -- Implementation: attributes

	last_node: EL_XML_NODE

	last_node_name: STRING_32

	last_node_text: STRING_32

	attribute_list: EL_XML_ATTRIBUTE_LIST
			--
		deferred
		end

	scanner: EL_XML_DOCUMENT_SCANNER

end
