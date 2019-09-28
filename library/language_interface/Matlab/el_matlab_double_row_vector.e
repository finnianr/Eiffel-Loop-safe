note
	description: "Matlab double row vector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MATLAB_DOUBLE_ROW_VECTOR

inherit
	EL_MATLAB_VECTOR_DOUBLE

create
	share_from_pointer, make, make_from_mx_pointer

feature -- Contract support

	is_orientation_valid (mx_matrix: POINTER): BOOLEAN
			--
		do
			Result := c_get_rows (mx_matrix) = 1
		end

feature {NONE} -- Implementation

	create_matrix (size: INTEGER): POINTER
			--
		do
			Result := c_create_double_matrix (1, size)
		end

	mx_count: INTEGER
			--
		do
			Result := c_get_columns (item)
		end

end