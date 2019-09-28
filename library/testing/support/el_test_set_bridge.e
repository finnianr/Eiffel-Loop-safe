note
	description: "[
		Access control for tests based on `EQA_TEST_SET'.
		See Larry Rix's [https://github.com/ljr1981/test_extension/blob/master/bridge/test_set_bridge.e explanation].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:29:59 GMT (Monday 1st July 2019)"
	revision: "3"

deferred class
	EL_TEST_SET_BRIDGE

inherit
	EL_MODULE_DIRECTORY

feature -- Constants

	Test_dir: EL_DIR_PATH
		once
			Result := Directory.current_working.joined_dir_path ("test")
		end
end
