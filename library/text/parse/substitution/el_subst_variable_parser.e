note
	description: "Subst variable parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_SUBST_VARIABLE_PARSER

inherit
	EL_PARSER

	EL_ZTEXT_PATTERN_FACTORY
		redefine
			c_identifier
		end

feature {NONE} -- Token actions

	on_literal_text (matched_text: EL_STRING_VIEW)
			--
		deferred
		end

	on_substitution_variable (matched_text: EL_STRING_VIEW)
			--
		deferred
		end

feature {NONE} -- Implemenation

	subst_variable: like one_of
			--
		do
			Result := one_of (<< variable, terse_variable >> )
		end

	variable: like all_of
			-- matches: ${name}
		do
			Result := all_of ( << string_literal ("${"), c_identifier, character_literal ('}') >> )
		end

	terse_variable: like all_of
			-- matches: $name
		do
			Result := all_of ( << character_literal ('$'), c_identifier >> )
		end

	c_identifier: like all_of
			--
		do
			Result := Precursor
			Result.set_action_first (agent on_substitution_variable)
		end

	new_pattern: EL_TEXT_PATTERN
			--
		local
			literal_text_pattern: EL_TEXT_PATTERN
		do
			literal_text_pattern := one_or_more (not one_character_from ("$"))
			literal_text_pattern.set_action (agent on_literal_text)

			Result := one_or_more (one_of (<< literal_text_pattern, subst_variable >>))
		end

end
