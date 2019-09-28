note
	description: "Graph point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_GRAPH_POINT

inherit
	SINGLE_MATH
		export
			{NONE} all
			{ANY} deep_copy,
				deep_twin,
				is_deep_equal,
				standard_is_equal
		end

create
	make, make_from_other

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER)
			-- Make a point and set
			-- `x', `y' with `a_x', `a_y'
		do
			x := a_x
			y := a_y
		ensure
			x_set: x = a_x
			y_set: y = a_y
		end

	make_from_other (other: EL_GRAPH_POINT)
			--
		do
			x := other.x
			y := other.y
		end


feature -- Element change

	set_x_y (a_x, a_y: INTEGER)
			-- Make a point and set
			-- `x', `y' with `a_x', `a_y'
		do
			x := a_x
			y := a_y
		ensure
			x_set: x = a_x
			y_set: y = a_y
		end

	set_from_other (other: EL_GRAPH_POINT)
			--
		do
			x := other.x
			y := other.y
		end

feature -- Measurement

	distance (other: EL_GRAPH_POINT): INTEGER
			--
		do
			Result := distance_x_y (other.x, other.y)
		end

	distance_x_y (ax, ay: INTEGER): INTEGER
			--
		local
			x_diff, y_diff: INTEGER
		do
			x_diff := x - ax
			y_diff := y - ay
			Result :=  sqrt (x_diff * x_diff + y_diff * y_diff).rounded
		end

feature -- Access

	x: INTEGER

	y: INTEGER

end
