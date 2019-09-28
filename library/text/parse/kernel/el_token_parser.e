note
	description: "Token parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:30:52 GMT (Wednesday 17th October 2018)"
	revision: "5"

deferred class
	EL_TOKEN_PARSER  [L -> EL_FILE_LEXER create make end]

inherit
	EL_FILE_PARSER
		rename
			source_text as tokens_text,
			source_view as tokens_view
		redefine
			make_default, set_source_text
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create {EL_STRING_8_VIEW} source_view.make (Empty_string_8)
			create token_text_array.make (0)
		end

feature -- Element change

	set_source_text (a_source_text: ZSTRING)
		local
			lexer: L
		do
			create lexer.make (a_source_text)
			Precursor (lexer.tokens_text)
			source_view := lexer.source_view
			token_text_array := lexer.token_text_array
		end

feature {NONE} -- Implementation

	source_text_for_token (i: INTEGER; matched_tokens: EL_STRING_VIEW): ZSTRING
			-- source text corresponding to i'th token in matched_tokens
		require
			valid_index: i >= 1 and i <= matched_tokens.count
			valid_token_text_array_index: matched_tokens.absolute_index (i) <= token_text_array.count
		do
			Result := source_view.interval_string (token_text_array @ matched_tokens.absolute_index (i))
		end

	token_text_array: ARRAYED_LIST [INTEGER_64]

	source_view: EL_STRING_VIEW

end
