note
	description: "Cortina set info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:33:23 GMT (Tuesday 10th September 2019)"
	revision: "2"

class
	CORTINA_SET_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			fade_in := 3.0; fade_out := 3.0
			clip_duration := 25
			tango_count := 8
			tangos_per_vals := 4
		end

feature -- Access

	clip_duration: INTEGER

	fade_in: REAL
		-- fade in duration

	fade_out: REAL
		-- fade out duration

	tango_count: INTEGER

	tangos_per_vals: INTEGER
end
