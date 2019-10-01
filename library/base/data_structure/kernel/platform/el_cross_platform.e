note
	description: "Cross platform"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_CROSS_PLATFORM [I -> EL_PLATFORM_IMPLEMENTATION create default_create end]

feature {NONE} -- Initialization

	make_default
			--
		do
			create internal_implementation
			implementation.set_interface (Current)
			implementation.make
		end

feature {NONE} -- Implementation

	implementation: I
		once ("OBJECT")
			check attached internal_implementation as al_item then Result := al_item end
		end

	internal_implementation: detachable like implementation

end
