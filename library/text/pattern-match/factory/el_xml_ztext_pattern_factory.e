note
	description: "Xml ztext pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_XML_ZTEXT_PATTERN_FACTORY

inherit
	EL_ZTEXT_PATTERN_FACTORY

feature -- Access

	comment (comment_action: like Default_action): like all_of
			--
		local
			comment_text: like while_not_p1_repeat_p2
		do
			comment_text := while_not_p1_repeat_p2 (string_literal ("-->"), any_character )
			comment_text.set_action_combined_p2 (comment_action)
			Result := all_of ( << string_literal ("<!--"), comment_text >> )
		end

	xml_identifier: like all_of
			--
		do
			Result := all_of (<<
				one_of_characters (<< letter, character_literal ('_') >>),
				zero_or_more (one_of_characters (<< alphanumeric, one_character_from (":_.-") >>))
			>>)
		end

	xml_attribute (name_action, value_action: like Default_action): like all_of
		local
			attribute_name: like xml_identifier; attribute_value: like while_not_p1_repeat_p2
		do
			attribute_name := xml_identifier
			if name_action /= Default_action then
				attribute_name.set_action_first (name_action)
			end
			attribute_value := while_not_p1_repeat_p2 (character_literal ('"'), any_character)
			if value_action /= Default_action then
				attribute_value.set_action_combined_p2 (value_action)
			end
			Result := all_of (<<
				attribute_name,
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				character_literal ('"'),
				attribute_value
			>>)
		end

end
