note
	description: "Xml parse event stream"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XML_PARSE_EVENT_STREAM

feature -- Event codes

	Parse_event_new_start_tag: INTEGER = 1

	Parse_event_existing_start_tag: INTEGER = 2

	Parse_event_end_tag: INTEGER = 3

	Parse_event_start_document: INTEGER = 4

	Parse_event_end_document: INTEGER = 5

	Parse_event_existing_attribute_name: INTEGER = 6

	Parse_event_new_attribute_name: INTEGER = 7

	Parse_event_attribute_text: INTEGER = 8

	Parse_event_text: INTEGER = 9

	Parse_event_existing_processing_instruction: INTEGER = 10

	Parse_event_new_processing_instruction: INTEGER = 11

	Parse_event_comment_text: INTEGER = 12

feature -- Constants

	Name_index_table_size: INTEGER = 31

feature {NONE} -- Implementation: attributes

	event_stream: IO_MEDIUM

end