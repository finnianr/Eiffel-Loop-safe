note
	description: "Uri routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-11 18:04:25 GMT (Wednesday 11th September 2019)"
	revision: "7"

deferred class
	EL_URI_ROUTINES

inherit
	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
			{ANY} deep_copy,
				deep_twin,
				is_deep_equal
		end

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

feature -- Status query

	is_http_uri (uri: ZSTRING): BOOLEAN
		do
			Result := is_uri (uri) and then Http_protocols.has (uri_protocol (uri))
		end

	is_uri (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		local
			pos_sign: INTEGER; uri: ZSTRING
		do
			uri := as_zstring (a_uri)
			pos_sign := uri.substring_index (Protocol_sign, 1)
			if pos_sign >= 3 and then uri.count > pos_sign + Protocol_sign.count
				and then is_alpha_string (uri.substring (1, pos_sign - 1))
			then
				Result := True
			end
		end

	is_uri_of_type (uri, type: ZSTRING): BOOLEAN
		local
			pos_sign: INTEGER
		do
			pos_sign := uri.substring_index (Protocol_sign, 1)
			if pos_sign > 0 and then uri.count > pos_sign + Protocol_sign.count
				and then uri.substring (1, pos_sign - 1) ~ type
			then
				Result := True
			end
		end

feature -- Access

	uri_path (uri: ZSTRING): ZSTRING
		local
			pos_sign: INTEGER
		do
			pos_sign := uri.substring_index (Protocol_sign, 1)
			if pos_sign >= 3 then
				Result := uri.substring (pos_sign + Protocol_sign.count, uri.count)
			else
				create Result.make_empty
			end
		end

	uri_protocol (uri: ZSTRING): ZSTRING
		do
			Result := uri.substring (1, uri.substring_index (Protocol_sign, 1) - 1)
		end

feature {NONE} -- Implementation

	is_alpha_string (str: ZSTRING): BOOLEAN
		do
			Result := str.linear_representation.for_all (agent is_a_to_z)
		end

	is_a_to_z (c: CHARACTER_32): BOOLEAN
		local
			code: INTEGER
		do
			code := c.natural_32_code.to_integer_32
			Result := {ASCII}.Lower_a <= code and code <= {ASCII}.Lower_z
		end

end
