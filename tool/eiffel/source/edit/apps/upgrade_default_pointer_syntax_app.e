note
	description: "[
		App to change syntax of default_pointers references: 
			ptr /= default_pointer TO is_attached (ptr)
			and ptr = default_pointer TO not is_attached (ptr)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "5"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_APP

inherit
	SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP
		redefine
			Option_name, test_run
		end

create
	make

feature {NONE} -- Implementation

	new_editor: UPGRADE_DEFAULT_POINTER_SYNTAX_EDITOR
		do
			create Result.make
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("sample-source/default_pointer", agent test_source_tree, checksum)
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 1575544618

	Option_name: STRING = "upgrade_default_pointer_syntax"

	Description: STRING = "[
		Change syntax of default_pointer references: 
		
			ptr /= default_pointer TO is_attached (ptr)
			ptr = default_pointer TO not is_attached (ptr)
	]"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{UPGRADE_DEFAULT_POINTER_SYNTAX_APP}, All_routines]
			>>
		end

end
