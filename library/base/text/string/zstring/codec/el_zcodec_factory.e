note
	description: "Factory for character codecs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_ZCODEC_FACTORY

inherit
	EL_FACTORY_CLIENT

	EL_SHARED_UTF_8_ZCODEC

feature {NONE} -- Factory

	new_codec (encoding: EL_ENCODING_BASE): EL_ZCODEC
		-- cached codec
		require
			has_codec: has_codec (encoding)
		local
			table: like Codec_table
		do
			if encoding.is_utf_id (8) then
				Result := Utf_8_codec

			elseif encoding.is_type_windows or encoding.is_type_latin then
				table := Codec_table
				if table.has_key (encoding.id) then
					Result := table.found_item
				else
					Result := new_codec_by_id (encoding.id)
					table.extend (Result, encoding.id)
				end
			else
				create {EL_ISO_8859_1_ZCODEC} Result.make
			end
		end

	new_codec_by_id (id: INTEGER): EL_ZCODEC
		do
			check has_codec: attached Codec_types [id] as al_codec_type then
				Result := Codec_factory.instance_from_type (al_codec_type, agent {EL_ZCODEC}.make)
			end
		end

feature {NONE} -- Status query

	has_codec (encoding: EL_ENCODING_BASE): BOOLEAN
		do
			if encoding.is_type_windows or encoding.is_type_latin then
				Result := Codec_types.has_key (encoding.id)

			elseif encoding.is_type_utf then
				Result := encoding.id = 8
			end
		end

feature {NONE} -- Constants

	Codec_table: HASH_TABLE [EL_ZCODEC, INTEGER]
		once
			create Result.make (30)
		end

	Codec_types: HASH_TABLE [TYPE [EL_ZCODEC], INTEGER]
		once
			create Result.make (30)
			Result [1] := {EL_ISO_8859_1_ZCODEC}
			Result [2] := {EL_ISO_8859_2_ZCODEC}
			Result [3] := {EL_ISO_8859_3_ZCODEC}
			Result [4] := {EL_ISO_8859_4_ZCODEC}
			Result [5] := {EL_ISO_8859_5_ZCODEC}
			Result [6] := {EL_ISO_8859_6_ZCODEC}
			Result [7] := {EL_ISO_8859_7_ZCODEC}
			Result [8] := {EL_ISO_8859_8_ZCODEC}
			Result [9] := {EL_ISO_8859_9_ZCODEC}
			Result [10] := {EL_ISO_8859_10_ZCODEC}
			Result [11] := {EL_ISO_8859_11_ZCODEC}

-- 		1SO-8859-12 is not available as it was missing from the original C-source code
--			used to generate codecs

			Result [13] := {EL_ISO_8859_13_ZCODEC}
			Result [14] := {EL_ISO_8859_14_ZCODEC}
			Result [15] := {EL_ISO_8859_15_ZCODEC}

			Result [1251] := {EL_WINDOWS_1251_ZCODEC}
			Result [1252] := {EL_WINDOWS_1252_ZCODEC}
			Result [1253] := {EL_WINDOWS_1253_ZCODEC}
			Result [1254] := {EL_WINDOWS_1254_ZCODEC}
			Result [1255] := {EL_WINDOWS_1255_ZCODEC}
			Result [1256] := {EL_WINDOWS_1256_ZCODEC}
			Result [1257] := {EL_WINDOWS_1257_ZCODEC}
			Result [1258] := {EL_WINDOWS_1258_ZCODEC}
		end

	Codec_factory: EL_OBJECT_FACTORY [EL_ZCODEC]
		once
			create Result
		end

end
