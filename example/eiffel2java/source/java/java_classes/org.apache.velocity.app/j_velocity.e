note
	description: "J velocity"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:28:54 GMT (Monday 1st July 2019)"
	revision: "5"

class
	J_VELOCITY

inherit
	ORG_APACHE_VELOCITY_APP_JPACKAGE

	JAVA_OBJECT_REFERENCE
		undefine
			new_lio
		end

	EL_MODULE_LOG
		rename
			Args as Command_args
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature -- Commands

	init
			--
		do
			log.enter ("init")
			jagent_init.call (Current, [])
			log.exit
		end

feature -- Access

	template (name: J_STRING): J_TEMPLATE
			--
		do
			log.enter_with_args ("template", [name.value])
			Result := jagent_template.item (Current, [name])
			log.exit
		end

feature {NONE} -- Implementation

	jagent_template: JAVA_STATIC_FUNCTION [J_VELOCITY, J_TEMPLATE]
			--
		once
			create Result.make ("getTemplate", agent template)
		end

feature {NONE} -- Java agents

	jagent_init: JAVA_STATIC_PROCEDURE [J_VELOCITY]
			--
		once
			create Result.make ("init", agent init)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Velocity")
		end

end -- class J_VELOCITY
