note
	description: "[
		Editor that reads text from a encodeable source and sends an edited version to output either
		directly or using one of the convenience routines: `put_string' or `put_new_line'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-02 9:19:49 GMT (Sunday 2nd June 2019)"
	revision: "4"

deferred class
	EL_TEXT_EDITOR

inherit
	EL_ENCODEABLE_AS_TEXT
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			output := Default_output
		end

feature -- Basic operations

	edit
		do
			output := new_output; output.set_encoding_from_other (Current)

			if is_bom_enabled and then attached {EL_PLAIN_TEXT_FILE} output then
				output.byte_order_mark.enable; output.put_bom
			end
			put_editions; close
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
		end

feature {NONE} -- Implementation

	close
			--
		do
			output.close
		end

	new_output: EL_OUTPUT_MEDIUM
			--
		deferred
		end

	put_editions
		deferred
		end

	put_new_line
			--
		do
			output.put_new_line
		end

	put_string (str: READABLE_STRING_GENERAL)
			-- Write `s' at current position.
		do
			output.put_string_general (str)
		end

feature {NONE} -- Internal attributes

	output: like new_output

feature {NONE} -- Constants

	Default_output: EL_ZSTRING_IO_MEDIUM
		once
			create Result.make (0)
		end

end
