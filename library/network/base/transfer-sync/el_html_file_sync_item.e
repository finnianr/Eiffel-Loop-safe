note
	description: "[
		HTML file-sync item that store CRC-32 digest in meta tag
			
			<meta name="digest" content="<crc digest>"/>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 14:10:45 GMT (Tuesday 5th March 2019)"
	revision: "5"

deferred class
	EL_HTML_FILE_SYNC_ITEM

inherit
	EL_CRC_32_SYNC_ITEM
		rename
			previous_digest as meta_crc_digest,
			make as make_sync
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

feature {NONE} -- Initialization

	make (html_path: EL_FILE_PATH)
		do
			make_machine
			if html_path.exists then
				do_once_with_file_lines (agent find_meta_digest, create {EL_PLAIN_TEXT_LINE_SOURCE}.make_latin (1, html_path))
			end
			make_sync
		end

feature {NONE} -- Line states: find meta checksum

	find_meta_digest (line: ZSTRING)
		do
			if line.has_substring (Digest_value) then
				meta_crc_digest := line.substring_between (Content_assignment, Meta_close, 1).to_natural
				state := final
			elseif line.has_substring (Head_close) then
				state := final
			end
		end

feature {NONE} -- Constants

	Content_assignment: ZSTRING
		once
			Result := "content=%""
		end

	Digest_value: ZSTRING
		once
			Result := "[
				"digest"
			]"
		end

	Meta_close: ZSTRING
		once
			Result := "%"/>"
		end

	Head_close: ZSTRING
		once
			Result := "</head>"
		end

end
