note
	description: "String editor test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-06 8:05:58 GMT (Tuesday 6th August 2019)"
	revision: "3"

class
	STRING_EDITOR_TEST_SET

inherit
	EQA_TEST_SET

	EL_ZSTRING_CONSTANTS

feature -- Tests

	test_edit
		local
			editor: EL_ZSTRING_EDITOR
			editor_8: EL_STRING_8_EDITOR; editor_32: EL_STRING_32_EDITOR
		do
			across << Empty_string, Asterisks >> as trailing loop
				across << Empty_string, Asterisks >> as leading loop
					create editor.make (leading.item + Target.multiplied (2) + trailing.item)
					editor.for_each ("[[", "]]", agent delete_interior)
					assert ("asterisks removed", editor.target ~ leading.item + Edited_target.multiplied (2) + trailing.item)
				end
			end
		end

feature {NONE} -- Implementation

	delete_interior (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.remove_substring (start_index, end_index)
		end

feature {NONE} -- Constants

	Asterisks: ZSTRING
		once
			Result := "**"
		end

	Edited_target: ZSTRING
		once
			Result := "[[]]**"
		end

	Target: ZSTRING
		once
			Result := "[[**]]**"
		end

end
