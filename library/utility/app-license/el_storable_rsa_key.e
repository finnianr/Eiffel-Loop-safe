note
	description: "Storable rsa key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 12:11:42 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_STORABLE_RSA_KEY

inherit
	EL_MODULE_RSA

feature {NONE} -- Implementation

	rsa_value (root_node: EL_XPATH_ROOT_NODE_CONTEXT; id: STRING): INTEGER_X
			--
		do
			if not id.is_empty then
				Value_xpath.set_variable ("id", id)
			end
			Result := Rsa.integer_x_from_base_64 (root_node.string_at_xpath (Value_xpath.substituted))
		end

	value_xpath: EL_STRING_8_TEMPLATE
			--
		deferred
		end

end
