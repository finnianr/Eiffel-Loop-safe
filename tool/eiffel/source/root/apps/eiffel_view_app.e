note
	description: "[
		**Eiffel-View** is a sub-application to publish source code and descriptions of Eiffel projects
		to a website as static html and generate a `Contents.md' file in Github markdown. 
		
		See [https://www.eiffel.org/blog/Finnian%20Reilly/2018/10/eiffel-view-repository-publisher-version-1-0-18
		eiffel.org article] and the [$source REPOSITORY_PUBLISHER] command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 10:29:56 GMT (Monday 2nd September 2019)"
	revision: "14"

class
	EIFFEL_VIEW_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_PUBLISHER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

feature {NONE} -- Constants

	Option_name: STRING = "eiffel_view"

	Description: STRING = "Publishes source code and descriptions of Eiffel projects to a website as static html"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{EIFFEL_VIEW_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines]
			>>
		end

end
