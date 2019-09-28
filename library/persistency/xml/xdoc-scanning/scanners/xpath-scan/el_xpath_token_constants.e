note
	description: "Xpath token constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XPATH_TOKEN_CONSTANTS

feature {NONE} -- Constants

	Comment_node: STRING_32 = "comment()"

	Child_element: STRING_32 = "*"

	Text_node: STRING_32 = "text()"

	Descendant_or_self_node: STRING_32 = "descendant-or-self::node()"

	Child_element_step_id: INTEGER_16 = 1

--	// is short for /descendant-or-self::node()/

	Descendant_or_self_node_step_id: INTEGER_16 = 2

	Comment_node_step_id: INTEGER = 3

	Text_node_step_id: INTEGER = 4

  	Num_step_id_constants: INTEGER
  		once
  			Result := Text_node_step_id
  		end

end