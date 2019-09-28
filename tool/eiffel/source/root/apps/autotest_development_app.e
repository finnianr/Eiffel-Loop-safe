note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 11:06:58 GMT (Wednesday 7th August 2019)"
	revision: "23"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Other tests

	tuple: TUPLE [NOTE_EDITOR_TEST_SET, UNDEFINE_PATTERN_COUNTER_TEST_SET]
		do
			create Result
		end

feature {NONE} -- Constants

	Evaluator_types: TUPLE [REPOSITORY_PUBLISHER_TEST_EVALUATOR]
		once
			create Result
		end

	Evaluator_types_all: TUPLE [REPOSITORY_PUBLISHER_TEST_EVALUATOR, REPOSITORY_SOURCE_LINK_EXPANDER_TEST_EVALUATOR]
		once
			create Result
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines],
				[{NOTE_EDITOR_TEST_SET}, All_routines],
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines],
				[{REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_TEST_SET}, All_routines],
				[{TEST_UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

end
