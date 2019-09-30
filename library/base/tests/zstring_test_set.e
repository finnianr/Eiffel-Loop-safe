note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ZSTRING_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	zstring_test
			-- New test routine
		local
			l_item: EL_ZSTRING
		do
			create l_item.make_empty
			assert_strings_equal ("empty_zstring", "", l_item.out)
			l_item := "abc"
			assert_strings_equal ("abc_zstring", "abc", l_item)
			l_item.append_string_general ("xyz")
			assert_strings_equal ("abcxyz_zstring", "abcxyz", l_item)
			l_item.insert_string (create {EL_ZSTRING}.make_from_string ("123"), 4)
			assert_strings_equal ("abc123xyz_zstring", "abc123xyz", l_item)
		end

end


