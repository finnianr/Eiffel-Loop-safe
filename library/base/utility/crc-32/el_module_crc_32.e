note
	description: "Module crc 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:19:50 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	EL_MODULE_CRC_32

inherit
	EL_MODULE

feature {NONE} -- Constants

	Crc_32: EL_CRC_32_ROUTINES
		once
			create Result
		end
end
