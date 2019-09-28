note
	description: "Test suite for Amazon Instant Access API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:00:44 GMT (Monday 1st July 2019)"
	revision: "8"

class
	AMAZON_INSTANT_ACCESS_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_MODULE_STRING_8

	EL_MODULE_EIFFEL

	AIA_SHARED_CREDENTIAL_LIST
		redefine
			credentials_file_path
		end

	AIA_SHARED_REQUEST_MANAGER

	AIA_SHARED_ENUMERATIONS

feature -- Account Linking

	test_response_code
		do
			assert ("same message", response_enum.name (response_enum.fail_other) ~ "FAIL_OTHER")
		end

	test_get_user_id
		note
			testing: "covers/{AIA_REQUEST_MANAGER}.response, covers/{EL_REFLECTIVELY_JSON_SETTABLE}.as_json"
		local
			request: like new_amazon_request
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "GetUserId",
					"infoField1": "nobody@amazon.com",
					"infoField2": "amazon",
					"infoField3": "nobody"
				}
			]")
			sign (request)
			request_get_user_id_1234 (request, "[
				{
					"response": "OK",
					"userId": "1234"
				}
			]")
		end

	test_get_user_id_health_check
		note
			testing: "covers/{AIA_REQUEST_MANAGER}.response, covers/{EL_REFLECTIVELY_JSON_SETTABLE}.as_json"
		local
			request: like new_amazon_request
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "GetUserId",
					"infoField1": "AMAZONTEST"
				}
			]")
			sign (request)
			request_get_user_id_1234 (request, "[
				{
					"response": "OK",
					"userId": ""
				}
			]")
		end

feature -- Authorization

	test_credential_storage
		do
			Credential_list.wipe_out
			new_credential_list.do_all (agent Credential_list.extend)
			assert ("same credential", Credential ~ Credential_list.first)
		end

	test_credential_id_equality
		local
			id_1, id_2: AIA_CREDENTIAL_ID
		do
			create id_1.make ("key/date")
			create id_2.make ("key" + "/date")
			assert ("equal", id_1 ~ id_2)
		end

	test_header_selection
		note
			testing: "covers/{FCGI_HTTP_HEADERS}.selected"
		local
			http_table: HASH_TABLE [ZSTRING, STRING]
			http_name: STRING; request: FCGI_REQUEST_PARAMETERS
			headers: HASH_TABLE [ZSTRING, STRING]
		do
         create http_table.make (5)
			from Signed_headers.start until Signed_headers.after loop
				http_name := "HTTP_" + Signed_headers.item.as_upper
				String_8.replace_character (http_name, '-', '_')
				http_table.extend (Signed_headers.index.out, http_name)
				Signed_headers.forth
			end
			create request.make_from_table (http_table)
			headers := request.headers.selected (Signed_headers)
			assert ("same count", headers.count = Signed_headers.count)
			assert ("same names", across headers as h all Signed_headers.has (h.key) end)
		end

	test_parse_header_1
		note
			testing: "covers/{AIA_AUTHORIZATION_HEADER}.parse"
		local
			header: AIA_AUTHORIZATION_HEADER
		do
         create header.make_from_string (
				"DTA1-HMAC-SHA256 %
				%SignedHeaders=Content-Type;X-Amz-Date;X-Amz-Dta-Version;X-AMZ-REQUEST-ID, %
	         %Credential=367caa91-cde5-48f2-91fe-bb95f546e9f0/20131207, %
	        	%Signature=87729cb3475859a18b5d9cead0bba82f0f56a85c2a13bed3bc229c6c35e06628"
         )
         assert ("same algorithm", header.algorithm ~ "DTA1-HMAC-SHA256")
         assert ("same Signed_headers", header.signed_headers_list ~ Signed_headers)
         assert ("same credential.key", header.credential.key ~ "367caa91-cde5-48f2-91fe-bb95f546e9f0")
         assert ("same credential.date", header.credential.date ~ "20131207")
         assert ("same signature", header.signature ~ "87729cb3475859a18b5d9cead0bba82f0f56a85c2a13bed3bc229c6c35e06628")
		end

	test_sign_and_verify
		local
			request: like new_amazon_request
			verifier: AIA_VERIFIER
		do
			request := new_amazon_request
			request.headers.set_accept ("*/*")
			request.set_request_uri ("/service/foo.php")
			request.set_content ("{%"operation%" : %"bar%"}")

			sign (request)
			create verifier.make (request, Credential_list)

			assert ("request is verified", verifier.is_verified)
		end

feature -- Purchase

	test_purchase_fullfill
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response, covers/{EL_REFLECTIVELY_JSON_SETTABLE}.as_json,
				covers/{AIA_PURCHASE_REQUEST}.response, covers/{EL_STATUS_CODE_VALUE}.make
			]"
		local
			request: like new_amazon_request; json_response: STRING
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "Purchase",
					"reason": "FULFILL",
					"productId": "GamePack1",
					"userId": "123456",
					"purchaseToken": "6f3092e5-0326-42b7-a107-416234d548d8"
				}
			]")
			sign (request)
			json_response := "[
				{
					"response": "FAIL_USER_NOT_ELIGIBLE"
				}
			]"
			Request_manager.purchase.set_new_response (agent purchase_with_ineligible_user)
			if attached {AIA_PURCHASE_RESPONSE} Request_manager.response (request) as l_response then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", l_response.as_json.to_latin_1 ~ json_response)
			else
				assert ("returned AIA_PURCHASE_RESPONSE", False)
			end
		end

	test_purchase_revoke
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response, covers/{EL_REFLECTIVELY_JSON_SETTABLE}.as_json,
				covers/{AIA_PURCHASE_REQUEST}.response, covers/{EL_STATUS_CODE_VALUE}.make
			]"
		local
			request: like new_amazon_request; json_response: STRING
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "Revoke",
					"reason": "CUSTOMER_SERVICE_REQUEST",
					"productId": "GamePack1",
					"userId": "123456",
					"purchaseToken": "6f3092e5-0326-42b7-a107-416234d548d8"
				}
			]")
			sign (request)
			json_response := "[
				{
					"response": "FAIL_INVALID_PURCHASE_TOKEN"
				}
			]"
			Request_manager.revoke_purchase.set_new_response (agent revoke_with_invalid_purchase_token)
			if attached {AIA_REVOKE_RESPONSE} Request_manager.response (request) as l_response then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", l_response.as_json.to_latin_1 ~ json_response)
			else
				assert ("returned AIA_REVOKE_RESPONSE", False)
			end
		end

feature {NONE} -- Request handlers

	get_user_id_1234 (request: AIA_GET_USER_ID_REQUEST): AIA_GET_USER_ID_RESPONSE
		do
			create Result.make (response_enum.ok)
			Result.set_user_id ("1234")
		end

	purchase_with_ineligible_user (request: AIA_PURCHASE_REQUEST): AIA_PURCHASE_RESPONSE
		do
			check_purchase_fields (request)
			create Result.make (response_enum.fail_user_not_eligible)
		end

	revoke_with_invalid_purchase_token (request: AIA_REVOKE_REQUEST): AIA_REVOKE_RESPONSE
		do
			check_purchase_fields (request)
			create Result.make (response_enum.fail_invalid_purchase_token)
		end

feature {NONE} -- Implementation

	check_purchase_fields (request: AIA_PURCHASE_REQUEST)
		do
			assert ("same", request.product_id ~ "GamePack1")
			assert ("same", request.user_id ~ "123456")
			assert ("same", request.purchase_token ~ "6f3092e5-0326-42b7-a107-416234d548d8")
		end

	new_amazon_request: FCGI_REQUEST_PARAMETERS
		do
			create Result.make
			Result.headers.set_host ("amazon.com")
			Result.headers.set_content_type ("application/json")

			Result.set_server_protocol ("HTTP/1.1")
			Result.set_server_port (80)
			Result.set_request_method ("POST")
			Result.set_request_uri ("/")
		end

	request_get_user_id_1234 (request: like new_amazon_request; json_response: STRING)
		do
			Request_manager.get_user_id.set_new_response (agent get_user_id_1234)
			if attached {AIA_GET_USER_ID_RESPONSE} Request_manager.response (request) as user_id_response then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", user_id_response.as_json.to_latin_1 ~ json_response)
			else
				assert ("returned AIA_GET_USER_ID_RESPONSE", False)
			end
		end

	sign (request: like new_amazon_request)
		local
			signer: AIA_SIGNER
		do
			create signer.make (request, credential)
			signer.sign
		end

feature {NONE} -- Events

	on_prepare
			-- Called after all initializations in `default_create'.
		do
			Precursor
			Credential_list.extend (Credential)
		end

feature {NONE} -- Constants

	Credentials_file_path: EL_FILE_PATH
		do
			Result := Work_area_dir + "credentials.dat"
		end

	Credential: AIA_CREDENTIAL
		once
			create Result.make ("SECRET", "PUBLIC")
		end

	Signed_headers: EL_SPLIT_STRING_LIST [STRING]
		once
			create Result.make ("Content-Type;X-Amz-Date;X-Amz-Dta-Version;X-AMZ-REQUEST-ID", ";")
		end

end
