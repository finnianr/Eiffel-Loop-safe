note
	description: "[
		Instant Access [https://s3-us-west-2.amazonaws.com/dtg-docs/api/account_linking.html account linking] request
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:21:06 GMT (Monday 18th December 2017)"
	revision: "3"

class
	AIA_GET_USER_ID_REQUEST

inherit
	AIA_REQUEST
		redefine
			response
		end

create
	make

feature -- Access

	info_field_1: ZSTRING

	info_field_2: ZSTRING

	info_field_3: ZSTRING

feature {NONE} -- Implementation

	response: AIA_RESPONSE
		do
			if info_field_1 ~ Amazon_test then
				Result := default_response
			else
				Result := new_response (Current)
			end
		end

	default_response: AIA_GET_USER_ID_RESPONSE
		do
			create Result.make (response_enum.ok)
		end

feature {NONE} -- Constants

	Amazon_test: ZSTRING
		once
			Result := "AMAZONTEST"
		end
end
