note
	description: "Svg point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	SVG_POINT

inherit
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make (attributes: EL_ELEMENT_ATTRIBUTE_TABLE; subscript: INTEGER)
			--
		local
			x_name, y_name: STRING
		do
			create x_name.make_from_string ("x")
			x_name.append_integer (subscript)

			create y_name.make_from_string ("y")
			y_name.append_integer (subscript)

			x := attributes.double (x_name)
			y := attributes.double (y_name)
		end

feature -- Access

	x, y: DOUBLE

feature -- Measurement

	distance (other: SVG_POINT): DOUBLE
			--
		do
			Result := sqrt (dabs ( (x - other.x) ^ 2.0 - (y - other.y) ^ 2.0))
		end

end