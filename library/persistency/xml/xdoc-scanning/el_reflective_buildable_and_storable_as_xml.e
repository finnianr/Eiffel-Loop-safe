note
	description: "[
		Object that can both 
			
			1. reflectively build itself from XML
			2. reflectively store itself as XML
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:57:45 GMT (Tuesday 10th September 2019)"
	revision: "10"

deferred class
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

inherit
	EL_FILE_PERSISTENT
		undefine
			make_from_file
		end

	EL_BUILDABLE_FROM_XML
		rename
			xml_name_space as xmlns
		undefine
			is_equal, new_building_actions, make_from_file
		redefine
			make_default
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default,
			xml_name_space as xmlns
		export
			{NONE} all
		redefine
			make_from_file, make_default, Except_fields
		end

	EL_MODULE_XML

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			file_path := a_file_path
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN} (a_file_path)
		end

	make_default
		do
			if not attached file_path then
				create file_path
			end
			create node_source.make (agent new_node_source)
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	put_xml_document (xml_out: EL_OUTPUT_MEDIUM)
		do
			xml_out.put_bom
			xml_out.put_string (XML.header (1.0, once "UTF-8"))
			xml_out.put_new_line
			put_xml_element (xml_out, root_node_name, 0)
		end

	store_as (a_file_path: EL_FILE_PATH)
		local
			xml_out: EL_PLAIN_TEXT_FILE
		do
			create xml_out.make_open_write (a_file_path)
			put_xml_document (xml_out)
			xml_out.close
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		local
			medium: EL_STRING_8_IO_MEDIUM
		do
			create medium.make (a_file.count)
			put_xml_document (medium)
			Result := medium.count = a_file.count
			medium.close
		end

	new_file (a_file_path: like file_path): EL_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (a_file_path)
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", file_path, last_store_ok"
		end

end
