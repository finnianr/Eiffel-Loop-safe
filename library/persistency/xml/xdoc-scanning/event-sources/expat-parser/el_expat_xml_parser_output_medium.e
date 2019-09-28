note
	description: "Expat xml parser output medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "8"

class
	EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM

inherit
	EL_EXPAT_XML_PARSER
		rename
			position as xml_position
		redefine
			make
		end

	EL_XML_PARSER_OUTPUT_MEDIUM
		rename
			make as make_output,
			put_character as put_raw_character_8,
			put_string as put_raw_string_8
		end

	EL_OUTPUT_MEDIUM
		rename
			codec as output_codec
		undefine
			make_default
		end

create
	make

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			make_output
			Precursor (a_scanner)
		end

feature -- Basic operations

	parse_from_serializable_object (object: EVOLICITY_SERIALIZEABLE_AS_XML)
			--
		local
			callback: like new_callback
		do
			reset
			callback := new_callback
			scanner.on_start_document
			object.serialize_to_stream (Current)
			if is_correct then
				finish_incremental
			end
			callback.release
		end

feature {NONE} -- Unimplemented

	open_read
		do
		end

	open_write
		do
		end

	position: INTEGER
		do
		end
end
