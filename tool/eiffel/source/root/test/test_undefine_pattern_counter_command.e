note
	description: "Test undefine pattern counter command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	TEST_UNDEFINE_PATTERN_COUNTER_COMMAND

inherit
	UNDEFINE_PATTERN_COUNTER_COMMAND
		redefine
			process_file
		end

create
	make

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
		do
			Precursor (source_path)
		ensure then
			valid_1: source_path.base.same_string ("eiffel_class.e") implies pattern_count = 9
			valid_1: source_path.base.same_string ("repository_source_tree_page.e") implies pattern_count = 2
			valid_1: source_path.base.same_string ("html_text_element_list.e") implies pattern_count = 3
		end
end
