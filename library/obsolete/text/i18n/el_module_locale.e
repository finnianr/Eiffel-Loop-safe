note
	description: "Summary description for {EL_LOCALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Locale: EL_LOCALE_ROUTINES
			--
		once
			create Result.make_platform
		end

end
