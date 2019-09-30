note
	description: "Helper Class for {EL_REFERENCE_FIELD_VALUE_TABLE}"
	design: "[
		Like all descendant classes, this class introduces specializations
		to {EL_FIELD_VALUE_TABLE}, but is deferred and designed to be inherited
		from together with {HASH_TABLE}, such that {HASH_TABLE} is further
		specialized as needed in descendants who inherit it and this class.
		]"
	history: "[
		Switching from 16.05 non-void-safe to 19.05 void-safety presented issues
		with creation procedure calls in directly inherited effective classes
		like {HASH_TABLE}. The 19.05 compiler in Conformance Void Safe mode
		would generate an error, disallowing inherited features to make creation
		calls. Therefore, it was needful to isolate the specialization features
		(found in this class) from the effective parent, and then re-introduce
		both this class and the effective parent with creation calls at precisely
		the point in downstream descendants as-needed.
		
		Please see the inheritance structure in the Class Tool to see how this is
		put together presently.
		]"


deferred class
	EL_REFERENCE_FIELD_VALUE_TABLE_HELPER [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- `make' Current with `n' items.
		do
			value_type := {G}
			default_condition := agent (v: G): BOOLEAN do end
			condition := default_condition
		end

feature {EL_REFLECTIVE} -- Placeholder Helpers

	item alias "[]" (key: STRING): detachable G
			-- `item' like {HASH_TABLE} `item'.
		note
			design: "[
				This feature is a temporary placeholder designed to
				facilitate calls or access in this class, but to be
				implemented by {HASH_TABLE}.item in direct descendants.
				]"
		deferred
		end

	extend (new: G; key: STRING_8)
			-- `extend' like {HASH_TABLE}.extend
		note
			design: "[
				This feature is a temporary placeholder designed to
				facilitate calls or access in this class, but to be
				implemented by {HASH_TABLE}.extend in direct descendants.
				]"
		deferred
		end

feature {EL_REFLECTIVE} -- Element change

	set_conditional_value (key: STRING; new: like item)
			-- `set_conditional_value' with a `key' and `new' `item'.
		do
			if attached new as al_new and then (condition /= default_condition implies condition (al_new)) then
				extend (al_new, key)
			end
		end

feature {EL_REFLECTIVELY_SETTABLE} -- Access

	set_value (key: STRING; a_value: ANY)
			-- `set_value' of `a_value' using `key' to locate `item'.
		do
			if attached {G} a_value as value then
				set_conditional_value (key, value)
			end
		end

	value_type_id: INTEGER
			-- What is the `value_type_id' of `value_type'?
		do
			Result := value_type.type_id
		end

end
