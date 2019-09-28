note
	description: "Org apache velocity jpackage"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	ORG_APACHE_VELOCITY_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant
	Package_name: STRING 
			--
		once
			Result := "org.apache.velocity"
		end
	
end -- class ORG_APACHE_VELOCITY_JPACKAGE