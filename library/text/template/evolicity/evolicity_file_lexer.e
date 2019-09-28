note
	description: "Evolicity file lexer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-19 9:07:43 GMT (Thursday   19th   September   2019)"
	revision: "5"

class
	EVOLICITY_FILE_LEXER

inherit
	EL_FILE_LEXER
		redefine
			make_default
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			identifier as evolicity_identifier,
			quoted_string as quoted_string_patterh
		end

	EVOLICITY_TOKENS

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			set_unmatched_action (add_token_action (Free_text))
		end

feature {NONE} -- Patterns

	across_directive: like all_of
			-- across <list_var_name> as <var> loop
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<< string_literal ("across")	|to| add_token_action (Keyword_across),
				variable_reference,
				string_literal ("as") 		|to| add_token_action (Keyword_as),
				variable_reference,
				string_literal ("loop") 	|to| add_token_action (Keyword_loop)
			>>)
		end

	boolean_expression: like all_of
			--
		do
			Result := all_of (<<
				simple_boolean_expression,
				zero_or_more (
					all_of (<<
						maybe_non_breaking_white_space,
						one_of (<<
							string_literal ("and") 	|to| add_token_action (Boolean_and_operator),
							string_literal ("or") 	|to| add_token_action (Boolean_or_operator)
						>>),
						maybe_non_breaking_white_space,
						simple_boolean_expression
					>>)
				)
			>>)
		end

	boolean_value: like one_of
			--
		do
			Result := one_of (<< simple_comparison_expression, variable_reference >>)
		end

	bracketed_boolean_value: like all_of
			--
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space, <<
				character_literal ('('), boolean_value, character_literal (')')
			>>)
		end

	comparison_operator: like one_of
			--
		do
			Result := one_of (<<
				string_literal (">")  |to| add_token_action (Greater_than_operator),
				string_literal ("<")  |to| add_token_action (Less_than_operator),
				string_literal ("=")  |to| add_token_action (Equal_to_operator),
				string_literal ("/=") |to| add_token_action (Not_equal_to_operator)
--				string_literal ("is_type") |to| add_token_action (Is_type_of_operator)
			>>)
		end

	constant: like one_of
			--
		do
			Result := one_of (<<
				quoted_manifest_string (Default_action)	|to| add_token_action (Quoted_string),
				double_constant									|to| add_token_action (Double_constant_token),
				integer_constant 									|to| add_token_action (Integer_64_constant_token)
			>>)
		end

	dollar_literal: like string_literal
			-- Example in Bash script
			
			-- RETVAL=$?
			-- if [ $$RETVAL -eq 0 ]
			-- then
		do
			Result := string_literal ("$$") |to| add_token_action (Double_dollor_sign)
		end

	evaluate_directive: like all_of
			-- evaluate ({<type name>}.template, $<variable name>)
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<< string_literal ("evaluate") 	|to| agent on_evaluate (Keyword_evaluate, ?),
				character_literal ('('),
				one_of (<<
					template_name_by_class	   |to| add_token_action (Template_name_identifier),
					variable_reference
				>>),
				character_literal (','),
				variable_reference,
				character_literal (')')
			>>)
		end

	foreach_directive: like all_of
			-- foreach <var> in <list_var_name> loop
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<  string_literal ("foreach")	|to| add_token_action (Keyword_foreach),
				variable_reference,
				string_literal ("in") 			|to| add_token_action (Keyword_in),
				variable_reference,
				string_literal ("loop") 		|to| add_token_action (Keyword_loop)
			>>)
		end

	function_call_pattern: like all_of
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				left_bracket_pattern,
				maybe_non_breaking_white_space,
				constant,
				while_not_p1_repeat_p2 (
					all_of (<< maybe_non_breaking_white_space, right_bracket_pattern >>),
					all_of (<<
						maybe_non_breaking_white_space,
						character_literal (',') 			|to| add_token_action (Comma_sign),
						maybe_non_breaking_white_space,
						constant
					>>)
				)
			>>)
		end

	if_directive: like all_of
			-- if <simple boolean expression> then
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space,

			<<	string_literal ("if") 	|to| add_token_action (Keyword_if),
				boolean_expression,
				string_literal ("then") |to| add_token_action (Keyword_then)
			>>)
		end

	include_directive: like all_of
			-- include ($<variable name>)
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space, <<
				string_literal ("include") |to| agent on_include (Keyword_include, ?),
				character_literal ('('), variable_reference, character_literal (')')
			>>)
		end

	leading_white_space: like all_of
		-- Fixes bug where #evaluate with no leading space uses tab count of previous #evaluate
		do
			Result := all_of (<< start_of_line, maybe_non_breaking_white_space >>)
			Result.set_action_first (agent on_leading_white_space)
		end

	left_bracket_pattern: like character_literal
			--
		do
			Result := character_literal ('(') |to| add_token_action (Left_bracket)
		end

	new_pattern: EL_TEXT_PATTERN
			--
		do
			Result := one_of (<< velocity_directive, dollar_literal, variable_reference >>)
		end

	parenthesized_qualified_variable_name: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('{'), qualified_variable_name, character_literal ('}')
			>>)
		end

	qualified_variable_name: like all_of
			--
		do
			Result := all_of (<<
				evolicity_identifier 				|to| add_token_action (Unqualified_name),
				zero_or_more (
					all_of (<<
						character_literal ('.') 	|to| add_token_action (Dot_operator),
						evolicity_identifier 		|to| add_token_action (Unqualified_name)
					>>)
				),
				optional (function_call_pattern)
			>>)
		end

	right_bracket_pattern: like character_literal
			--
		do
			Result := character_literal (')') |to| add_token_action (Right_bracket)
		end

	simple_boolean_expression: like one_of
			--
		do
			Result := one_of (<<
				boolean_value,
				all_of (<<
					string_literal ("not") |to| add_token_action (Boolean_not_operator),
					maybe_non_breaking_white_space,
					one_of (<< variable_reference, bracketed_boolean_value >>)
				>>)
			>>)
		end

	simple_comparison_expression: like all_of
			--
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space, <<
				variable_reference_or_constant, comparison_operator, variable_reference_or_constant
			>>)
		end

	template_name_by_class: like all_of
			--
		do
			Result := all_of (<< character_literal ('{'), class_name, string_literal ("}.template") >>)
		end

	variable_reference: like all_of
			-- Eg: ${clip.offset}
		do
			Result := all_of (<<
				character_literal ('$'),
				one_of (<< qualified_variable_name, parenthesized_qualified_variable_name >>)
			>>)
		end

	variable_reference_or_constant: like one_of
			--
		do
			Result := one_of (<< variable_reference, constant >>)
		end

	velocity_directive: like all_of
			--
		do
			Result := all_of (<<
				leading_white_space,
				character_literal ('#'),
				one_of (<<
					string_literal ("end") 			|to| add_token_action (Keyword_end),
					if_directive,
					across_directive,
					foreach_directive,
					string_literal ("else") 		|to| add_token_action (Keyword_else),
					evaluate_directive,
					include_directive
				>>),
				maybe_non_breaking_white_space,
				end_of_line_character
			>>)
		end

feature {NONE} -- Actions

	on_evaluate, on_include (keyword_token: NATURAL_32; token_text: EL_STRING_VIEW)
			--
		do
			tokens_text.append_code (keyword_token)
			token_text_array.extend (token_text.interval)
			tokens_text.append_code (White_text)
			token_text_array.extend (leading_space_text)
		end

	on_leading_white_space (text: EL_STRING_VIEW)
			--
		do
			leading_space_text := text.interval
		end

feature {NONE} -- Implementation

	leading_space_text: INTEGER_64

feature {NONE} -- Constants

	Template_ending: ZSTRING
		once
			Result := "}.template"
		end
end
