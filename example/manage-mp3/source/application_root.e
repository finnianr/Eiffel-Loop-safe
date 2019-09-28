note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 8:55:20 GMT (Thursday   26th   September   2019)"
	revision: "9"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		ID3_EDITOR_APP,
		MP3_AUDIO_SIGNATURE_READER_APP,
		RHYTHMBOX_MUSIC_MANAGER_APP,
		TANGO_MP3_FILE_COLLATOR_APP,
		EL_DEBIAN_PACKAGER_APP,

--		Testing
		TEST_RHYTHMBOX_MUSIC_MANAGER_APP,
		TEST_APP
	]
		once
			create Result
		end

end
