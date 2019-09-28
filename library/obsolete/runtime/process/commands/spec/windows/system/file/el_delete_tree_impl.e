note
	description: "Summary description for {EL_DELETE_TREE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 10:08:59 GMT (Tuesday 17th May 2016)"
	revision: "1"

class
	EL_DELETE_TREE_IMPL

inherit
	EL_OS_COMMAND_IMPL

create
	default_create

feature -- Access

	template: STRING = "rmdir /Q /S $target_path"

end