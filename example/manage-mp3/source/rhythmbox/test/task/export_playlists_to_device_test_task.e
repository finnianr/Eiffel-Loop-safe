note
	description: "Export playlists to device test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-15 9:31:04 GMT (Sunday   15th   September   2019)"
	revision: "3"

class
	EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK

inherit
	EXPORT_PLAYLISTS_TO_DEVICE_TASK
		undefine
			root_node_name, new_device
		redefine
			apply
		end

	EXPORT_TO_DEVICE_TEST_TASK

create
	make

feature -- Basic operations

	apply
		do
			Precursor
			-- and again
			log.put_line ("Removing first playlist")
				-- Expected behaviour is that it shouldn't delete anything
			Database.playlists.start
			Database.playlists.remove
			Precursor
		end

end
