note
	description: "Export to device test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 10:15:06 GMT (Tuesday 3rd September 2019)"
	revision: "2"

deferred class
	EXPORT_TO_DEVICE_TEST_TASK

inherit
	EXPORT_TO_DEVICE_TASK
		undefine
			root_node_name
		redefine
			new_device
		end

	TEST_MANAGEMENT_TASK

feature -- Factory

	new_device: TEST_STORAGE_DEVICE
		do
			create Result.make (Current)
		end

end
