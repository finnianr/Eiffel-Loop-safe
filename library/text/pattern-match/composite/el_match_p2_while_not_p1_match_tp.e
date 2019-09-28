note
	description: "Match p2 while not p1 match tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MATCH_P2_WHILE_NOT_P1_MATCH_TP

inherit
	EL_MATCH_LOOP_TP
		rename
			set_action_combined_p1 as set_action_combined_p2
		redefine
			name, make, match_count
		end

create
	make

feature {NONE} -- Initialization

	make (p1, p2: EL_TEXT_PATTERN)
		do
			Precursor (p2, p1)
		end

feature -- Access

	name: STRING
		do
			Result := "while (not " + conditional_pattern.name + "): " + repeated.name
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		local
			l_conditional: like conditional_pattern
			done: BOOLEAN; repeat_count, sum_repeat_count: INTEGER
		do
			l_conditional := conditional_pattern
			from until done loop
				l_conditional.match (text)
				if l_conditional.is_matched then
					done := True
				else
					repeat_count := repeat_match_count (text)
					if repeat_count > 0 then
						text.prune_leading (repeat_count)
						sum_repeat_count := sum_repeat_count + repeat_count
					else
						done := True
					end
				end
			end
			Result := sum_repeat_count + l_conditional.count
			if Result = 0 then
				Result := Match_fail
			end
		end

end