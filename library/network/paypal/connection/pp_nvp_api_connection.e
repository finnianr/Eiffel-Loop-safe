note
	description: "Paypal NVP API connection accessible via `{[$source PP_SHARED_API_CONNECTION]}.paypal'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-27 18:42:48 GMT (Tuesday 27th August 2019)"
	revision: "12"

class
	PP_NVP_API_CONNECTION

inherit
	PP_HTTP_CONNECTION
		rename
			make as make_http_connection,
			open as open_url
		export
			{NONE} open_url
			{PP_BUTTON_METHOD} last_string, set_post_parameters, read_string_post, has_error, reset
		end

	EL_REFLECTIVE
		rename
			field_included as is_button_parameter,
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature {NONE} -- Initialization

	make (a_api_version: REAL)
		do
			credentials := Configuration.new_credentials
			create version.make (a_api_version)
			make_http_connection
			create button_search.make (Current)
			create create_button.make (Current)
			create get_button_details_method.make (Current)
			create manage_button_status.make (Current)
			create update_button.make (Current)

			across field_table as button loop
				button.item.set (Current, create {PP_BUTTON_PARAMETER}.make (button.key))
			end
		end

feature -- Access

	api_url: ZSTRING
		do
			Result := Configuration.api_url
		end

	notify_url: STRING
		-- The URL to which PayPal posts information about the payment,
		-- in the form of Instant Payment Notification messages.
		do
			Result := Configuration.notify_url
		end

	domain_name: STRING
		do
			Result := Configuration.domain_name
		end

feature -- Button management

	button_search_results: PP_BUTTON_SEARCH_RESULTS
			-- list all buttons since year 2000
		do
			Result := button_search.query_result ([create {PP_DATE_TIME_RANGE}.make_to_now (Jan_1st_2000)])
		end

	create_buy_now_button (
		locale: PP_BUTTON_LOCALE; sub_parameter_list: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := create_button.call ([locale, button_code_hosted, button_type_buynow, sub_parameter_list, buy_options])
		end

	delete_button (button: PP_HOSTED_BUTTON): PP_HTTP_RESPONSE
		do
			Result := manage_button_status.call ([button, button_status_delete])
		end

	get_button_details (button: PP_HOSTED_BUTTON): PP_BUTTON_DETAILS_QUERY_RESULTS
		do
		 	Result := get_button_details_method.query_result ([button])
		end

	update_buy_now_button (
		locale: PP_BUTTON_LOCALE; button: PP_HOSTED_BUTTON
		sub_parameter_list: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := update_button.call ([
				locale, button, button_code_hosted, button_type_buynow, button_sub_type_products,
				sub_parameter_list, buy_options
			])
		end

feature -- Basic operations

	open
		do
			open_url (api_url)
		end

feature -- Status query

	last_call_succeeded: BOOLEAN
		do
			Result := not has_error
		end

feature {NONE} -- Implementation

	is_button_parameter (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := type_id = Button_parameter_type
		end

feature {PP_BUTTON_METHOD} -- Paypal parameters

	button_code_hosted: PP_BUTTON_PARAMETER

	button_status_delete: PP_BUTTON_PARAMETER

	button_sub_type_products: PP_BUTTON_PARAMETER

	button_type_buynow: PP_BUTTON_PARAMETER

	credentials: PP_CREDENTIALS

	version: PP_API_VERSION

feature {NONE} -- Methods

	button_search: PP_BUTTON_SEARCH_METHOD

	create_button: PP_CREATE_BUTTON_METHOD

	get_button_details_method: PP_GET_BUTTON_DETAILS_METHOD

	manage_button_status: PP_MANAGE_BUTTON_STATUS_METHOD

	update_button: PP_UPDATE_BUTTON_METHOD

feature {NONE} -- Constants

	Button_parameter_type: INTEGER
		once
			Result := ({PP_BUTTON_PARAMETER}).type_id
		end

	Jan_1st_2000: DATE_TIME
		once
			create Result.make (2000, 1, 1, 0, 0, 0)
		end

end
