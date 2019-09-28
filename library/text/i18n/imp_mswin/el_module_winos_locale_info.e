note
	description: "Module winos locale info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MODULE_WINOS_LOCALE_INFO

feature {NONE} -- Constants

	Win_os_locale_info: I18N_LOCALE_INFO
		local
			locale_imp: I18N_HOST_LOCALE_IMP
		once
			create locale_imp
			Result := locale_imp.create_locale_info_from_user_locale
		end

end