note
	description: "Verifies Instant Access request as authentic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 14:30:22 GMT (Monday 5th November 2018)"
	revision: "5"

class
	AIA_VERIFIER

inherit
	AIA_SIGNER
		rename
			make as make_signer
		export
			{NONE} sign
		redefine
			headers_list
		end

create
	make

feature {NONE} -- Initialization

	make (a_request: like request; credential_list: EL_CHAIN [AIA_CREDENTIAL])
		local
			authorization: ZSTRING
		do
			make_signer (a_request, Default_credential)
			iso8601_time := request.headers.custom (Header_x_amz_date)
			authorization := request.headers.authorization
			if not authorization.is_empty then
				create actual_authorization_header.make_from_string (authorization)
				credential_list.find_first_equal (actual_authorization_header.credential.key, agent {AIA_CREDENTIAL}.public)
				if credential_list.found then
					credential := credential_list.item
				end
			else
				create actual_authorization_header.make
			end
		end

feature -- Status query

	is_verified: BOOLEAN
		local
			request_time: DATE_TIME
		do
			if not iso8601_time.is_empty then
				request_time := Date.from_ISO_8601_formatted (iso8601_time)
				if request_time.relative_duration (time_now).seconds_count.abs < Time_tolerance_in_secs then
					Result := authorization_header ~ actual_authorization_header
				end
			end
		end

feature {NONE} -- Implementation

	headers_list: EL_SPLIT_STRING_LIST [STRING]
		do
			Result := actual_authorization_header.signed_headers_list
		end

feature {NONE} -- Internal attributes

	actual_authorization_header: AIA_AUTHORIZATION_HEADER

feature {NONE} -- Constants

	Default_credential: AIA_CREDENTIAL
		once
			create Result.make_default
		end

	Time_tolerance_in_secs: INTEGER_64
		once
			Result := 15 * 60
		end

end
