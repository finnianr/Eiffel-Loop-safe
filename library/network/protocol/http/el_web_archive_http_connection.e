note
	description: "Class to find archive URL in the Wayback Machine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-03 12:23:42 GMT (Sunday 3rd March 2019)"
	revision: "4"

class
	EL_WEB_ARCHIVE_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION

	EL_MODULE_TUPLE

create
	make

feature -- Access

	wayback (a_url: like url): EL_WAYBACK_CLOSEST
		local
			pos_closest, pos_triple_brackets: INTEGER; json: STRING
		do
			Parameter_table [once "url"] := a_url
			open_with_parameters (Wayback_available_url, Parameter_table)
			read_string_get
			if has_error then
				create Result.make_default
			else
				pos_closest := last_string.substring_index (Json_closest, 1)
				if pos_closest > 0 then
					pos_triple_brackets := last_string.substring_index (Json_triple_bracket, pos_closest + Json_closest.count)
					json := last_string.substring (pos_closest + Json_closest.count + 1, pos_triple_brackets)
					create Result.make (json)
				else
					create Result.make_default
				end
			end
			close
		end

feature -- Status query

	is_wayback_available (a_url: like url): BOOLEAN
			-- `True' is wayback is availabe for `a_url'
		do
			Result := wayback (a_url).available
		end

feature {NONE} -- Implementation

	wayback_json_field (a_url: like url; field_name: ZSTRING): ZSTRING
			-- archived URL of `a_url'. Returns empty string if not found.
		local
			json: ZSTRING
		do
			Parameter_table [once "url"] := a_url
			open_with_parameters (Wayback_available_url, Parameter_table)
			read_string_get
			if has_error then
				create Result.make_empty
			else
				json := last_string
				Result := json.substring_between (Delimiter_template #$ [field_name], Json_comma_delimiter, 1)
			end
			close
		end

feature {NONE} -- Constants

	Delimiter_template: ZSTRING
		once
			Result := "%"%S%":%""
		end

	Json_comma_delimiter: ZSTRING
		once
			Result := ","
			Result.quote (2)
		end

	Json_closest: STRING = "[
		"closest":
	]"

	Json_triple_bracket: STRING = "}}}"

	Parameter_table: HASH_TABLE [ZSTRING, STRING]
		once
			create Result.make (1)
		end

	Wayback_available_url: ZSTRING
		once
			Result := "http://archive.org/wayback/available"
		end

end
