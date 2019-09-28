note
	description: "[
		Descendant of [$source EL_WORK_DISTRIBUTER] specialized for procedures.
		`G' is the target type of the procedures you wish to execute.
		For an example on how to use see [$source TEST_WORK_DISTRIBUTER_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:33:56 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER
		rename
			collect as collect_procedures,
			collect_final as collect_final_procedures
		redefine
			unassigned_routine
		end

create
	make

feature -- Basic operations

	collect (result_list: LIST [G])
		do
			restrict_access
				if not applied.is_empty then
					from applied.start until applied.after loop
						if attached {G} applied.item.target as target then
							result_list.extend (target)
						end
						applied.remove
					end
				end
			end_restriction
		end

	collect_final (result_list: LIST [G])
		do
			from final_applied.start until final_applied.after loop
				if attached {G} final_applied.item.target as target then
					result_list.extend (target)
				end
				final_applied.remove
			end
		end

feature {NONE} -- Implementation

	unassigned_routine: detachable PROCEDURE
		-- routine that is not yet assigned to any thread for execution

end
