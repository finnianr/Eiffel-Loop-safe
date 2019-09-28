note
	description: "[
		Supporting class for lists implementing [$source EL_QUERYABLE_CHAIN]
		Use it to create various compound query conditions and derive a query condition object
		from an agent predicate.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 15:06:26 GMT (Monday 5th November 2018)"
	revision: "6"

class
	EL_QUERY_CONDITION_FACTORY [G]

feature -- Access

	any: EL_ANY_QUERY_CONDITION [G]
		do
			create Result
		end

	all_of (conditions: ARRAY [EL_QUERY_CONDITION [G]]): EL_ALL_OF_QUERY_CONDITION [G]
		do
			create Result.make (conditions)
		end

	one_of (conditions: ARRAY [EL_QUERY_CONDITION [G]]): EL_ONE_OF_QUERY_CONDITION [G]
		do
			create Result.make (conditions)
		end

	predicate (a_predicate: PREDICATE [G]): EL_PREDICATE_QUERY_CONDITION [G]
		do
			create Result.make (a_predicate)
		end

	same_value (target_value: ANY; value: FUNCTION [G, ANY]): EL_FUNCTION_VALUE_QUERY_CONDITION [G]
		do
			create Result.make (target_value, value)
		end

end
