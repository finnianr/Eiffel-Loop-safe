note
	description: "Summary description for {EL_REFERENCE_FIELD_VALUE_TABLE_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_REFERENCE_FIELD_VALUE_TABLE_HELPER [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
--			Precursor (n)
			value_type := {G}
			default_condition := agent (v: G): BOOLEAN do end
			condition := default_condition
		end

feature -- Helpers

	item alias "[]" (key: STRING): detachable G
		deferred
		end

feature {EL_REFLECTIVE} -- Element change

	set_conditional_value (key: STRING; new: like item)
		do
			if attached new as al_new and then (condition /= default_condition implies condition (al_new)) then
				extend (al_new, key)
			end
		end

	extend (new: G; key: STRING_8) 
		deferred
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
