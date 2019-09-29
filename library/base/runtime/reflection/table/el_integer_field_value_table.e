note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for the `INTEGER' type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_INTEGER_FIELD_VALUE_TABLE

inherit
	HASH_TABLE [INTEGER, STRING]
		rename
			make as make_with_count,
			make_equal as make
		redefine
			make
		end

	EL_FIELD_VALUE_TABLE [INTEGER]
		rename
			value_type_id as integer_type
		end

create
	make,
	make_with_count

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			value_type := {INTEGER}
			default_condition := agent (v: INTEGER): BOOLEAN do end
			condition := default_condition
		end

feature {EL_REFLECTIVE} -- Element change

	set_conditional_value (key: STRING; new: like item)
		do
			if attached new as al_new and then (condition /= default_condition implies condition (al_new)) then
				extend (al_new, key)
			end
		end

feature {NONE} -- Implementation

	set_value (key: STRING; value: INTEGER)
		do
			set_conditional_value (key, value)
		end

end
