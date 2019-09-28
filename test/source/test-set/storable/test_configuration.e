note
	description: "Test configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:59:14 GMT (Tuesday 10th September 2019)"
	revision: "7"

class
	TEST_CONFIGURATION

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		redefine
			make_default, new_instance_functions
		end

create
	make_from_file, make

feature {NONE} -- Initialization

	make (a_image_path: like image_path; a_name: like name; a_values: like values)
		do
			make_default
			image_path := a_image_path; name := a_name; values := a_values
		end

	make_default
		do
			create values_list.make (3)
			values_list.compare_objects
			create colors.make (3)
			create integer_list.make (3)
			colors.compare_objects
			clipping := True
			Precursor
		end

feature {NONE} -- Implementation

	new_instance_functions: ARRAY [FUNCTION [ANY]]
		do
			Result := <<
				agent: like values do create Result.make_default end
			>>
		end

feature -- Access

	colors: ARRAYED_LIST [STRING]

	image_path: EL_FILE_PATH

	integer_list: ARRAYED_LIST [INTEGER]

	substring_interval: TUPLE [start_index, end_index: INTEGER]

	name: STRING

	values: TEST_VALUES

	values_list: ARRAYED_LIST [TEST_VALUES]

feature -- Status query

	clipping: EL_BOOLEAN_OPTION
end
