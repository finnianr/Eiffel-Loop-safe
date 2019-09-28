note
	description: "J object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	J_OBJECT

inherit
	JAVA_LANG_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	default_create,
	make,
	make_from_pointer,
	make_from_java_method_result,
	make_from_java_attribute

feature -- Access

	to_string: J_STRING
			--
		do
			Result := jagent_to_string.item (Current, [])
		end

feature {NONE} -- Implementation

	jagent_to_string: JAVA_FUNCTION [J_OBJECT, J_STRING]
			--
		once
			create Result.make ("toString", agent to_string)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Object")
		end

end -- class J_OBJECT