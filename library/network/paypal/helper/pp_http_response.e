note
	description: "Deserialized response to Paypal HTTP method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:14:31 GMT (Monday 1st July 2019)"
	revision: "5"

class
	PP_HTTP_RESPONSE

inherit
	EL_URL_QUERY_TABLE
		undefine
			is_equal
		end

	PP_SETTABLE_FROM_UPPER_CAMEL_CASE
		redefine
			Hidden_fields
		end

	EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make_count (n: INTEGER)
		do
			make_default
		end

feature -- Basic operations

	print_values
		do
			if is_ok then
				print_fields (lio)
			else
				print_error
			end
		end

feature -- Paypal fields

	ack: STRING

	build: NATURAL

	correlation_id: STRING

	http_read_ok: BOOLEAN

	time_stamp: EL_ISO_8601_DATE_TIME

	version: STRING

feature -- Status query

	is_ok: BOOLEAN
		do
			Result := http_read_ok and ack.starts_with (Success)
			-- "SuccessWithWarning" is a possible ACK response
		end

feature -- Element change

	set_http_read_ok (a_http_read_ok: like http_read_ok)
		do
			http_read_ok := a_http_read_ok
		end

feature {NONE} -- Implementation

	print_error
		do
			lio.put_line ("ERROR")
		end

	set_name_value (key, value: EL_ZSTRING)
		local
			table: like field_table
		do
			table := field_table
			if table.has_name (key, Current) then
				set_reflected_field (table.found_item, Current, value)
			else
				set_indexed_value (variable (key), value)
			end
		end

feature {NONE} -- Implementation

	set_indexed_value (var_key: PP_L_VARIABLE; a_value: ZSTRING)
		do
		end

	variable (key: ZSTRING): PP_L_VARIABLE
		do
			Result := Once_variable
			Result.set_from_string (key)
		end

feature {NONE} -- Constants

	Once_variable: PP_L_VARIABLE
		once
			create Result.make_default
		end

	Success: STRING = "Success"

feature {NONE} -- Constants

	Hidden_fields: STRING
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		once
			Result := "time_stamp"
		end

end
