note
	description: "Abstract definition of positions in XML documents"
	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

deferred class EL_XML_POSITION

inherit

	ANY
		redefine
			out
		end

feature -- Access

	source: EL_XML_SOURCE
			-- Source from where position is taken
		deferred
		end

feature -- Output

	out: STRING
			-- Textual representation
		do
			Result := source.out
		end

invariant

	source_not_void: source /= Void

end
