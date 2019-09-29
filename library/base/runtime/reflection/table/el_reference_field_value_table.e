note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for reference field attribute types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	HASH_TABLE [G, STRING]
		rename
			make as make_with_count,
			make_equal as make
		redefine
			make
		end

	EL_FIELD_VALUE_TABLE [G]

create
	make,
	make_with_count

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			value_type := {G}
			default_condition := agent (v: G): BOOLEAN do end
			condition := default_condition
		end

feature {EL_REFLECTIVE} -- Element change

	set_conditional_value (key: STRING; new: like item)
		do
			if attached new as al_new and then (condition /= default_condition implies condition (al_new)) then
				extend (al_new, key)
			end
		end

feature {EL_REFLECTIVELY_SETTABLE} -- Access

	set_value (key: STRING; a_value: ANY)
		do
			if attached {G} a_value as value then
				set_conditional_value (key, value)
			end
		end

	value_type_id: INTEGER
		do
			Result := value_type.type_id
		end
end
