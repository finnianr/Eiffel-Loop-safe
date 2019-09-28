note
	description: "Application that can be regression tested"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-06 11:18:26 GMT (Friday 6th September 2019)"
	revision: "6"

deferred class
	EL_REGRESSION_TESTABLE_SUB_APPLICATION

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			new_log_manager, new_lio, new_log_filter_list
		end

	EL_MODULE_TEST

feature {NONE} -- Initialization

	initialize
			--
		do
			if not skip_normal_initialize then
				normal_initialize
			end
		end

feature -- Basic operations

	run
			--
		do
			if is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
				test_run
				if not Test.last_test_succeeded then
					exit_code := 1
				end
			else
				normal_run
			end
		end

feature -- Status query

	Is_test_mode: BOOLEAN
			--
		once
			Result := Args.word_option_exists ("test")
		end

feature {NONE} -- Factory

	new_lio: EL_LOGGABLE
		do
			if logging.is_active then
				Result := Once_log
			else
				create {EL_TESTING_CONSOLE_ONLY_LOG} Result.make (Test.Crc_32)
			end
		end

	new_log_manager: EL_LOG_MANAGER
		do
			create {EL_TESTING_LOG_MANAGER} Result.make (Test.Crc_32)
		end

feature {NONE} -- Implementation

	new_log_filter_list: ARRAYED_LIST [EL_LOG_FILTER]
		do
			Result := Precursor
			if not across Result as filter some filter.item.class_type ~ {EL_REGRESSION_TESTING_ROUTINES} end
			then
				Result.extend (new_log_filter ({EL_REGRESSION_TESTING_ROUTINES}, All_routines))
			end
		end

	normal_initialize
			--
		deferred
		end

	normal_run
			--
		deferred
		end

	skip_normal_initialize: BOOLEAN
		do
			Result := is_test_mode
		end

	test_run
			--
		deferred
		end

end
