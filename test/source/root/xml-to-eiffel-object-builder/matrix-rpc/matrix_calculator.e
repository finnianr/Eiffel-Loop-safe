note
	description: "[
		Perform calculations on matrix with procedure specified in processing instruction

			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?create {MATRIX_CALCULATOR}?>
			<matrix>
				<row>
					<col>1.15</col>
					<col>0.2</col>
					<col>0.5</col>
					<col>1.12</col>
					<col>0.2</col>
					<col>0.5</col>
				</row>
				<row>
					<col>0.1</col>
					<col>0.28</col>
					<col>0.5</col>
					<col>6.2</col>
					<col>0.55</col>
					<col>0.1</col>
				</row>
			<matrix>
			<?procedure find_column_average?>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:51:19 GMT (Monday 1st July 2019)"
	revision: "5"

class
	MATRIX_CALCULATOR

inherit
	ARRAYED_LIST [ARRAY [REAL]]
		rename
			make as make_array,
			last as row,
			count as row_count
		end

	EL_BUILDABLE_FROM_XML
		undefine
			copy, is_equal
		redefine
			make_default, building_action_table, PI_building_action_table, on_context_exit
		end

	EL_MODULE_LOG

create
	make_from_file, make_from_string

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			make_array (10)
			create vector_result.make (1, 0)
			create row_sum.make (1, 0)
		end

feature -- Access

	vector_result: ARRAY [REAL]

feature -- Basic operations

	find_column_sum
			-- find sum of columns
		local
			i: INTEGER
		do
			log.enter ("find_column_sum")
			vector_result.grow (row.count)
			from start until after loop
				from i := 1 until i > row.count loop
					vector_result [i] := vector_result [i] + row [i]
					i := i + 1
				end
				forth
			end
			log_vector_result ("Sum")
			log.exit
		end

	find_column_average
			-- find average of columns
		local
			i: INTEGER
		do
			log.enter ("find_column_average")
			find_column_sum
			from i := 1 until i > row.count loop
				vector_result [i] := vector_result [i] / row_count
				i := i + 1
			end
			log_vector_result ("Average")
			log.exit
		end

feature {NONE} -- Implementation

	log_vector_result (label: STRING)
			--
		do
			across vector_result as l_result loop
				log.put_string (label + " column [" + l_result.cursor_index.out + "] = ")
				log.put_real (l_result.item)
				log.put_new_line
			end
		end

	calculation_procedure: PROCEDURE

	row_sum: ARRAY [REAL]

	col_index: INTEGER

feature {NONE} -- Building from XML

	add_row
			--
		do
			lio.put_line ("add_row")
			if is_empty then
				extend (create {ARRAY [REAL]}.make (1, 0))
			else
				extend (create {ARRAY [REAL]}.make (1, row.count))
			end
			col_index := 0
		end

	add_row_col
			--
		do
			log.enter ("add_row_col")
			col_index := col_index + 1
			log.put_integer_field ("col_index", col_index)
			row.force (node.to_real, col_index)
			log.exit
		end

	do_calculation
			--
		do
			log.enter ("do_calculation")
			if Procedures.has_key (node.to_string) then
				Procedures.found_item.set_target (Current)
				Procedures.found_item.apply

			end
			log.exit
		end

	on_context_exit
			--
		do
--			calculation_procedure.apply
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Relative to root node: matrix
		do
			create Result.make (<<
				-- matrix sibling node

				["row", agent add_row],
				["row/col/text()", agent add_row_col]
			>>)
		end

	PI_building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["processing-instruction('call')", agent do_calculation]
			>>)
		end

	Root_node_name: STRING = "matrix"

feature {NONE} -- Constants

	Procedures: EL_HASH_TABLE [PROCEDURE, STRING]
			--
		once
			create Result.make (<<
				["find_column_sum", agent find_column_sum],
				["find_column_average", agent find_column_average]
			>>)
		end

end
