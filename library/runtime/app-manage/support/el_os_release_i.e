note
	description: "Basic OS release information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:29:45 GMT (Wednesday 17th October 2018)"
	revision: "3"

deferred class
	EL_OS_RELEASE_I

inherit
	EL_ZSTRING_CONSTANTS

	EL_SHARED_ONCE_STRINGS

feature -- Access

	description: ZSTRING
		do
			Result := Template #$ [name, major_version, minor_version]
		end

	major_version: INTEGER
		deferred
		end

	minor_version: INTEGER
		deferred
		end

	name: ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "%S: %S.%S"
		end
end
