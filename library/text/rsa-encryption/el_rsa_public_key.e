note
	description: "Reflectively createable RSA public key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_RSA_PUBLIC_KEY

inherit
	RSA_PUBLIC_KEY
		rename
			make as make_with_exponent
		end

	EL_MODULE_BASE_64

	EL_MODULE_RSA

	EL_REFLECTIVE_RSA_KEY

	EL_MODULE_X509_COMMAND

create
	make, make_from_array, make_from_base_64, make_from_hex_byte_sequence, make_from_manifest,
	make_from_map_list, make_from_pkcs1, make_from_x509_cert

feature {NONE} -- Initialization

	make_default
		do
			make (2)
		end

	make_from_hex_byte_sequence (sequence: STRING)
			-- used to intialize from X509 cert
		do
			make (RSA.integer_x_from_hex_sequence (sequence))
		end

	make_from_base_64 (base_64_string: STRING)
			--
		do
			make_from_array (Base_64.decoded_array (base_64_string))
		end

	make_from_array (a_modulus: ARRAY [NATURAL_8])
			--
		do
			make (Rsa.integer_x_from_array (a_modulus.area))
		end

	make_from_manifest (a_modulus: ARRAY [INTEGER])
		-- use to intialize from manifest containing factorized digits multiplied back together
		-- This form should make it more difficult for pirates to alter the machine code of executable
		local
			l_area: SPECIAL [NATURAL_8]
		do
			create l_area.make_filled (0, a_modulus.count)
			across a_modulus as n loop
				l_area [n.cursor_index - 1] := n.item.to_natural_8
			end
			make (Rsa.integer_x_from_array (l_area))
		end

	make_from_x509_cert (crt_file_path: EL_FILE_PATH)
		local
			reader_cmd: like X509_command.new_certificate_reader
		do
			reader_cmd := X509_command.new_certificate_reader (crt_file_path)
			reader_cmd.execute
			make_from_pkcs1 (reader_cmd.lines)
		end

	make (a_modulus: INTEGER_X)
			--
		do
			make_with_exponent (a_modulus, Default_exponent)
		end

feature -- Basic operations

	verify_base_64 (message: INTEGER_X; base64_signature: STRING): BOOLEAN
			--
		do
			Result := verify (message, Rsa.integer_x_from_base_64 (base64_signature))
		end

	encrypt_base_64 (base64_message: STRING): INTEGER_X
			--
		local
			message: INTEGER_X
		do
			message := Rsa.integer_x_from_base_64 (base64_message)
			Result := encrypt (message)
		end

end
