note
	description: "Summary description for {EL_PYXIS_ATTRIBUTE_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:00:03 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EL_PYXIS_ATTRIBUTE_PARSER

inherit
	EL_PARSER
		rename
			match_full as parse
		redefine
			parse
		end

	EL_PYXIS_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_PYTHON_UNESCAPE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create attribute_list.make (5)
		end

feature -- Access

	attribute_list: ARRAYED_LIST [like last_attribute]

feature -- Basic operations

	parse
			--
		do
			attribute_list.wipe_out
			Precursor
			if full_match_succeeded then
				consume_events
			end
		end

feature {NONE} -- Pattern definitions		

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				assignment,
				zero_or_more (
					all_of (<<
						maybe_non_breaking_white_space,
						character_literal (';'),
						maybe_non_breaking_white_space,
						assignment
					>>)
				)
			>>)
		end

	assignment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				attribute_identifier |to| agent on_name,
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				one_of (<<
					xml_identifier |to| agent on_value,
					numeric_constant |to| agent on_value,
					quoted_string_with_escape_sequence (double_quote_escape_sequence, agent on_quoted_value (?, True)),
					single_quoted_string_with_escape_sequence (single_quote_escape_sequence, agent on_quoted_value (?, False))
				>>)
			>> )
		end

feature {NONE} -- Title parsing actions

	on_name (matched_text: EL_STRING_VIEW)
			--
		do
			create last_attribute
			last_attribute.name := matched_text
			last_attribute.name.replace_character ('.', ':')
			attribute_list.extend (last_attribute)
		end

	on_value (matched_text: EL_STRING_VIEW)
			--
		do
			last_attribute.value := matched_text
		end

	on_quoted_value (matched_text: EL_STRING_VIEW; is_double_quote: BOOLEAN)
			--
		do
			if is_double_quote then
				last_attribute.value := matched_text.to_string.unescaped (Escape_character, Double_quote_escape_table)
			else
				last_attribute.value := matched_text.to_string.unescaped (Escape_character, Single_quote_escape_table)
			end
		end

feature {NONE} -- Implementation

	last_attribute: TUPLE [name, value: EL_ASTRING]

end