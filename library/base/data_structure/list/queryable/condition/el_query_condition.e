note
	description: "Query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 11:50:38 GMT (Sunday 4th November 2018)"
	revision: "6"

deferred class
	EL_QUERY_CONDITION [G]

feature -- Access

	met (item: G): BOOLEAN
		-- True if condition is met for `item`
		deferred
		end

feature -- Addition

	conjuncted alias "and" (right: EL_QUERY_CONDITION [G]): EL_AND_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	disjuncted alias "or" (right: EL_QUERY_CONDITION [G]): EL_OR_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	negated alias "not": EL_NOT_QUERY_CONDITION [G]
		do
			create Result.make (Current)
		end

end
