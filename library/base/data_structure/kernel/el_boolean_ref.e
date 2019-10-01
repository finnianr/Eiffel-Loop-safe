note
	description: "[
		Binary state object that can be associated with a descriptive name pair. `on' or `off' for example.
	]"
	notes: "[
		In a descendant, rename `item' to the "true name", `on' for example, and redefine `false_name' as the opposite,
		which in this example would be `off'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 11:35:34 GMT (Monday 23rd April 2018)"
	revision: "4"

class
	EL_BOOLEAN_REF

inherit
	BOOLEAN_REF
		redefine
			out
		end

	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		undefine
			out
		end

	EL_MAKEABLE_FROM_STRING_8
		rename
			make as make_from_string
		undefine
			out
		end

create
	make, make_default, make_from_string

convert
	make ({BOOLEAN}), item: {BOOLEAN}

feature {NONE} -- Initialization

	make (a_item: BOOLEAN)
		do
			item := a_item
		end

	make_default
		do
		end

	make_from_string (value: STRING)
		do
			set_from_string (value)
		end

feature -- Access

	out, to_string: STRING
		do
			if item then
				Result := true_name
			else
				Result := false_name
			end
		end

feature -- Element change

	set_from_string (value: STRING)
		do
			item := true_name ~ value
		ensure then
			reversible: out ~ value
		end

feature {NONE} -- Implementation

	true_name: STRING
		do
			check attached Meta_data_by_type.item (Current) as al_meta_item and then
					attached al_meta_item.field_array.item (1) as al_item_1
			then
				Result := al_item_1.name
			end
		end

	false_name: STRING
		once
			Result := "False"
		end

end
