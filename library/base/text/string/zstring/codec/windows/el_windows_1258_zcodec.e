﻿note
	description: "Codec for WINDOWS_1258 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_WINDOWS_1258_ZCODEC

inherit
	EL_ZCODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_2 := latin_set_from_array (<<
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_3 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_4 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
			latin_set_5 := latin_set_from_array (<<
				204, -- '̀'
				236  -- '́'
			>>)
			latin_set_6 := latin_set_from_array (<<
				150, -- '–'
				151  -- '—'
			>>)
			latin_set_7 := latin_set_from_array (<<
				254, -- '₫'
				128  -- '€'
			>>)
			latin_set_8 := latin_set_from_array (<<
				213, -- 'Ơ'
				245  -- 'ơ'
			>>)
			latin_set_9 := latin_set_from_array (<<
				195, -- 'Ă'
				227  -- 'ă'
			>>)
			latin_set_10 := latin_set_from_array (<<
				140, -- 'Œ'
				156  -- 'œ'
			>>)
			latin_set_11 := latin_set_from_array (<<
				208, -- 'Đ'
				240  -- 'đ'
			>>)
			latin_set_12 := latin_set_from_array (<<
				221, -- 'Ư'
				253  -- 'ư'
			>>)
		end

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..235, 237..241, 243..246, 248..253 then
					offset := 32
				when 156 then
					offset := 16
				when 255 then
					offset := 96

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 192..203, 205..209, 211..214, 216..221 then
					offset := 32
				when 140 then
					offset := 16
				when 159 then
					offset := 96

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect code
				-- ƒ -> Ƒ
				when 131 then
					Result := 'Ƒ'
				-- µ -> Μ
				when 181 then
					Result := 'Μ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1258
		do
			inspect uc
				when '†'..'•' then
					Result := latin_set_1 [unicode - 8224]
				when '“'..'„' then
					Result := latin_set_2 [unicode - 8220]
				when '‘'..'‚' then
					Result := latin_set_3 [unicode - 8216]
				when '‹'..'›' then
					Result := latin_set_4 [unicode - 8249]
				when '̀'..'́' then
					Result := latin_set_5 [unicode - 768]
				when '–'..'—' then
					Result := latin_set_6 [unicode - 8211]
				when '₫'..'€' then
					Result := latin_set_7 [unicode - 8363]
				when 'Ơ'..'ơ' then
					Result := latin_set_8 [unicode - 416]
				when 'Ă'..'ă' then
					Result := latin_set_9 [unicode - 258]
				when 'Œ'..'œ' then
					Result := latin_set_10 [unicode - 338]
				when 'Đ'..'đ' then
					Result := latin_set_11 [unicode - 272]
				when 'Ư'..'ư' then
					Result := latin_set_12 [unicode - 431]
				when '…' then
					Result := '%/133/'
				when 'Ÿ' then
					Result := '%/159/'
				when '‰' then
					Result := '%/137/'
				when '˜' then
					Result := '%/152/'
				when '™' then
					Result := '%/153/'
				when '̃' then
					Result := '%/222/'
				when 'ˆ' then
					Result := '%/136/'
				when '̉' then
					Result := '%/210/'
				when '̣' then
					Result := '%/242/'
				when 'ƒ' then
					Result := '%/131/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code
				when 65..90, 97..122, 131, 140, 156, 159, 181, 192..203, 205..209, 211..214, 216..221, 223..235, 237..241, 243..246, 248..253, 255 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code
				when 97..122, 224..235, 237..241, 243..246, 248..253, 156, 255 then
					Result := True

				-- Characters which are only available in a single case
				when 131, 181, 223 then
					Result := True

			else
			end
		end

	is_numeric (code: NATURAL): BOOLEAN
		do
			inspect code
				when 48..57 then
					Result := True
			else
			end
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			inspect code
				when 65..90, 192..203, 205..209, 211..214, 216..221, 140, 159 then
					Result := True
			else
			end
		end

feature {NONE} -- Implementation

	new_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by WINDOWS_1258 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := '€' -- EURO SIGN
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x83] := 'ƒ' -- LATIN SMALL LETTER F WITH HOOK
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x88] := 'ˆ' -- MODIFIER LETTER CIRCUMFLEX ACCENT
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x8C] := 'Œ' -- LATIN CAPITAL LIGATURE OE
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x98] := '˜' -- SMALL TILDE
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0x9C] := 'œ' -- LATIN SMALL LIGATURE OE
			Result [0x9F] := 'Ÿ' -- LATIN CAPITAL LETTER Y WITH DIAERESIS
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := '¡' -- INVERTED EXCLAMATION MARK
			Result [0xA2] := '¢' -- CENT SIGN
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA5] := '¥' -- YEN SIGN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := 'ª' -- FEMININE ORDINAL INDICATOR
			Result [0xAB] := '«' -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xAC] := '¬' -- NOT SIGN
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := '¯' -- MACRON
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := '±' -- PLUS-MINUS SIGN
			Result [0xB2] := '²' -- SUPERSCRIPT TWO
			Result [0xB3] := '³' -- SUPERSCRIPT THREE
			Result [0xB4] := '´' -- ACUTE ACCENT
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := '¸' -- CEDILLA
			Result [0xB9] := '¹' -- SUPERSCRIPT ONE
			Result [0xBA] := 'º' -- MASCULINE ORDINAL INDICATOR
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := '¼' -- VULGAR FRACTION ONE QUARTER
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBE] := '¾' -- VULGAR FRACTION THREE QUARTERS
			Result [0xBF] := '¿' -- INVERTED QUESTION MARK
			Result [0xC0] := 'À' -- LATIN CAPITAL LETTER A WITH GRAVE
			Result [0xC1] := 'Á' -- LATIN CAPITAL LETTER A WITH ACUTE
			Result [0xC2] := 'Â' -- LATIN CAPITAL LETTER A WITH CIRCUMFLEX
			Result [0xC3] := 'Ă' -- LATIN CAPITAL LETTER A WITH BREVE
			Result [0xC4] := 'Ä' -- LATIN CAPITAL LETTER A WITH DIAERESIS
			Result [0xC5] := 'Å' -- LATIN CAPITAL LETTER A WITH RING ABOVE
			Result [0xC6] := 'Æ' -- LATIN CAPITAL LETTER AE
			Result [0xC7] := 'Ç' -- LATIN CAPITAL LETTER C WITH CEDILLA
			Result [0xC8] := 'È' -- LATIN CAPITAL LETTER E WITH GRAVE
			Result [0xC9] := 'É' -- LATIN CAPITAL LETTER E WITH ACUTE
			Result [0xCA] := 'Ê' -- LATIN CAPITAL LETTER E WITH CIRCUMFLEX
			Result [0xCB] := 'Ë' -- LATIN CAPITAL LETTER E WITH DIAERESIS
			Result [0xCC] := '̀' -- COMBINING GRAVE ACCENT
			Result [0xCD] := 'Í' -- LATIN CAPITAL LETTER I WITH ACUTE
			Result [0xCE] := 'Î' -- LATIN CAPITAL LETTER I WITH CIRCUMFLEX
			Result [0xCF] := 'Ï' -- LATIN CAPITAL LETTER I WITH DIAERESIS
			Result [0xD0] := 'Đ' -- LATIN CAPITAL LETTER D WITH STROKE
			Result [0xD1] := 'Ñ' -- LATIN CAPITAL LETTER N WITH TILDE
			Result [0xD2] := '̉' -- COMBINING HOOK ABOVE
			Result [0xD3] := 'Ó' -- LATIN CAPITAL LETTER O WITH ACUTE
			Result [0xD4] := 'Ô' -- LATIN CAPITAL LETTER O WITH CIRCUMFLEX
			Result [0xD5] := 'Ơ' -- LATIN CAPITAL LETTER O WITH HORN
			Result [0xD6] := 'Ö' -- LATIN CAPITAL LETTER O WITH DIAERESIS
			Result [0xD7] := '×' -- MULTIPLICATION SIGN
			Result [0xD8] := 'Ø' -- LATIN CAPITAL LETTER O WITH STROKE
			Result [0xD9] := 'Ù' -- LATIN CAPITAL LETTER U WITH GRAVE
			Result [0xDA] := 'Ú' -- LATIN CAPITAL LETTER U WITH ACUTE
			Result [0xDB] := 'Û' -- LATIN CAPITAL LETTER U WITH CIRCUMFLEX
			Result [0xDC] := 'Ü' -- LATIN CAPITAL LETTER U WITH DIAERESIS
			Result [0xDD] := 'Ư' -- LATIN CAPITAL LETTER U WITH HORN
			Result [0xDE] := '̃' -- COMBINING TILDE
			Result [0xDF] := 'ß' -- LATIN SMALL LETTER SHARP S
			Result [0xE0] := 'à' -- LATIN SMALL LETTER A WITH GRAVE
			Result [0xE1] := 'á' -- LATIN SMALL LETTER A WITH ACUTE
			Result [0xE2] := 'â' -- LATIN SMALL LETTER A WITH CIRCUMFLEX
			Result [0xE3] := 'ă' -- LATIN SMALL LETTER A WITH BREVE
			Result [0xE4] := 'ä' -- LATIN SMALL LETTER A WITH DIAERESIS
			Result [0xE5] := 'å' -- LATIN SMALL LETTER A WITH RING ABOVE
			Result [0xE6] := 'æ' -- LATIN SMALL LETTER AE
			Result [0xE7] := 'ç' -- LATIN SMALL LETTER C WITH CEDILLA
			Result [0xE8] := 'è' -- LATIN SMALL LETTER E WITH GRAVE
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ê' -- LATIN SMALL LETTER E WITH CIRCUMFLEX
			Result [0xEB] := 'ë' -- LATIN SMALL LETTER E WITH DIAERESIS
			Result [0xEC] := '́' -- COMBINING ACUTE ACCENT
			Result [0xED] := 'í' -- LATIN SMALL LETTER I WITH ACUTE
			Result [0xEE] := 'î' -- LATIN SMALL LETTER I WITH CIRCUMFLEX
			Result [0xEF] := 'ï' -- LATIN SMALL LETTER I WITH DIAERESIS
			Result [0xF0] := 'đ' -- LATIN SMALL LETTER D WITH STROKE
			Result [0xF1] := 'ñ' -- LATIN SMALL LETTER N WITH TILDE
			Result [0xF2] := '̣' -- COMBINING DOT BELOW
			Result [0xF3] := 'ó' -- LATIN SMALL LETTER O WITH ACUTE
			Result [0xF4] := 'ô' -- LATIN SMALL LETTER O WITH CIRCUMFLEX
			Result [0xF5] := 'ơ' -- LATIN SMALL LETTER O WITH HORN
			Result [0xF6] := 'ö' -- LATIN SMALL LETTER O WITH DIAERESIS
			Result [0xF7] := '÷' -- DIVISION SIGN
			Result [0xF8] := 'ø' -- LATIN SMALL LETTER O WITH STROKE
			Result [0xF9] := 'ù' -- LATIN SMALL LETTER U WITH GRAVE
			Result [0xFA] := 'ú' -- LATIN SMALL LETTER U WITH ACUTE
			Result [0xFB] := 'û' -- LATIN SMALL LETTER U WITH CIRCUMFLEX
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ư' -- LATIN SMALL LETTER U WITH HORN
			Result [0xFE] := '₫' -- DONG SIGN
			Result [0xFF] := 'ÿ' -- LATIN SMALL LETTER Y WITH DIAERESIS
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

	latin_set_4: SPECIAL [CHARACTER]

	latin_set_5: SPECIAL [CHARACTER]

	latin_set_6: SPECIAL [CHARACTER]

	latin_set_7: SPECIAL [CHARACTER]

	latin_set_8: SPECIAL [CHARACTER]

	latin_set_9: SPECIAL [CHARACTER]

	latin_set_10: SPECIAL [CHARACTER]

	latin_set_11: SPECIAL [CHARACTER]

	latin_set_12: SPECIAL [CHARACTER]

end
