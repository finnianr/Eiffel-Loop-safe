note
	description: "Command-line interface to command [$source IMP_CLASS_LOCATION_NORMALIZER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 10:29:56 GMT (Monday 2nd September 2019)"
	revision: "2"

class
	IMP_CLASS_LOCATION_NORMALIZER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [IMP_CLASS_LOCATION_NORMALIZER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

feature {NONE} -- Constants

	Option_name: STRING = "normalize_imp_location"

	Description: STRING = "Normalizes location of implementation classes in relation to respective interfaces"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{IMP_CLASS_LOCATION_NORMALIZER_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines]
			>>
		end

end
