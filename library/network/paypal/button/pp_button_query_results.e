note
	description: "Results of a NVP button API query"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 18:13:55 GMT (Saturday 28th April 2018)"
	revision: "4"

class
	PP_BUTTON_QUERY_RESULTS

inherit
	PP_HTTP_RESPONSE

create
	make_default, make

feature -- Access

	alt_button_description: ZSTRING
		do
			Result := website_code
			if not Result.is_empty then
				Result := Result.substring_between (Alt_attribute, Quote_character, 1)
			end
		end

	hosted_button: PP_HOSTED_BUTTON
		do
			create Result.make (hosted_button_id)
		end

feature -- Paypal fields

	hosted_button_id: STRING

	website_code: ZSTRING

feature {NONE} -- Constants

	Alt_attribute: ZSTRING
		once
			Result := "alt=%""
		end

	Assignment: CHARACTER = '='

	Quote_character: ZSTRING
		once
			Result := "%""
		end

end
