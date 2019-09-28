note
	description: "[
		Routines for AES encryption and creating SHA or MD5 digests. Accessible via [$source EL_MODULE_ENCRYPTION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 9:19:49 GMT (Wednesday   25th   September   2019)"
	revision: "6"

class
	EL_ENCRYPTION_ROUTINES

inherit
	EL_BASE_64_ROUTINES

	EL_AES_CONSTANTS
		export
			{ANY} Bit_sizes
		end

feature -- Conversion

	base64_decrypt (key, cipher: STRING): STRING
			-- decrypt base64 encoded cipher with base64 encoded key array
		local
			encrypter: EL_AES_ENCRYPTER
		do
			create encrypter.make_from_key (decoded_array (key))
			Result := encrypter.decrypted_base64 (cipher)
		end

	plain_pyxis (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 3)
		end

	plain_text (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 0)
		end

feature -- Factory

	new_aes_encrypter (pass_phrase: ZSTRING; bit_count: NATURAL): EL_AES_ENCRYPTER
		require
			valid_bit_count: Bit_sizes.has (bit_count)
		do
			create Result.make (pass_phrase, bit_count)
		end

feature {NONE} -- Implementation

	plain_text_from_line (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_line_start: INTEGER): STRING
		local
			file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path)
			file.set_line_start (a_line_start)
			file.set_encrypter (a_encrypter)
			create Result.make (file.count * 7 // 10)
			from file.read_line until file.after loop
				if not Result.is_empty then
					Result.append_character ('%N')
				end
				Result.append (file.last_string)
				Result.prune_all_trailing ('%R')
				file.read_line
			end
			file.close
		end

end
