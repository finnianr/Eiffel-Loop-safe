note
	description: "Searcher for Augmented Latin strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:13:11 GMT (Wednesday 16th December 2015)"
	revision: "1"

frozen class
	EL_ASTRING_SEARCHER

inherit
	STRING_SEARCHER

create
	make

feature -- Access

	string_type: EL_ASTRING
			-- <Precursor>
		do
			create Result.make_empty
		end

	max_code_point_value: INTEGER = 2_000
			-- We optimize the search for the first 2000 code points of Unicode (i.e. using 8KB of memory).

feature -- Search

	substring_index_with_deltas (a_string: like string_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
			-- Position of first occurrence of `a_pattern' at or after `start_pos' in `a_string'.
			-- 0 if there are no matches.
		local
			i, j, l_end_pos: INTEGER
			l_pattern_count: INTEGER
			l_matched: BOOLEAN
			l_deltas: like deltas
			l_area: SPECIAL [CHARACTER]
			l_area_lower: INTEGER
			l_char_code, l_upper_place_holder: NATURAL
		do
			if a_string = a_pattern then
				if start_pos = 1 then
					Result := 1
				end
			else
				l_pattern_count := a_pattern.count
				check l_pattern_count_positive: l_pattern_count > 0 end
				from
					l_area := a_string.area
					l_area_lower := a_string.area_lower
					i := start_pos + l_area_lower
					l_deltas := deltas
					l_end_pos := end_pos + 1 + l_area_lower
					l_upper_place_holder := a_string.upper_place_holder.natural_32_code
				until
					i + l_pattern_count > l_end_pos
				loop
					from
						j := 0
						l_matched := True
					until
						j = l_pattern_count
					loop
						l_char_code := code_or_foreign_code (i + j - 1, l_area, a_string, l_upper_place_holder)
						if l_char_code /= a_pattern.code (j + 1) then
								-- Mismatch, so we stop
							j := l_pattern_count - 1	-- Jump out of loop
							l_matched := False
						end
						j := j + 1
					end

					if l_matched then
							-- We got the substring
						Result := i - l_area_lower
						i := l_end_pos	-- Jump out of loop
					else
							-- Pattern was not found, shift to next location
						if i + l_pattern_count <= end_pos then
							l_char_code := code_or_foreign_code (i + l_pattern_count - 1, l_area, a_string, l_upper_place_holder)
							if l_char_code.to_integer_32 > max_code_point_value then
									-- Character is too big, we revert to a slow comparison
								i := i + 1
							else
								i := i + l_deltas.item (l_char_code.to_integer_32)
							end
						else
							i := i + 1
						end
					end
				end
			end
		end

	fuzzy_index (a_string: like string_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos, fuzzy: INTEGER): INTEGER
			-- Position of first occurrence of `a_pattern' at or after `start_pos' in
			-- `a_string' with 0..`fuzzy' mismatches between `a_string' and `a_pattern'.
			-- 0 if there are no fuzzy matches.
		local
			i, j, l_min_offset, l_end_pos: INTEGER
			l_pattern_count, l_nb_mismatched: INTEGER
			l_matched: BOOLEAN
			l_deltas_array: like deltas_array
			l_area: SPECIAL [CHARACTER]
			l_area_lower: INTEGER
			l_char_code, l_upper_place_holder: NATURAL
		do
			if fuzzy = a_pattern.count then
					-- More mismatches than the pattern length.
				Result := start_pos
			else
				if fuzzy = 0 then
					Result := substring_index (a_string, a_pattern, start_pos, end_pos)
				else
					initialize_fuzzy_deltas (a_pattern, fuzzy)
					l_deltas_array := deltas_array
					if l_deltas_array /= Void then
						from
							l_pattern_count := a_pattern.count
							l_area := a_string.area
							l_area_lower := a_string.area_lower
							i := start_pos + l_area_lower
							l_end_pos := end_pos + 1 + l_area_lower
							l_upper_place_holder := a_string.upper_place_holder.natural_32_code
						until
							i + l_pattern_count > l_end_pos
						loop
							from
								j := 0
								l_nb_mismatched := 0
								l_matched := True
							until
								j = l_pattern_count
							loop
								l_char_code := code_or_foreign_code (i + j - 1, l_area, a_string, l_upper_place_holder)
								if l_char_code /= a_pattern.code (j + 1) then
									l_nb_mismatched := l_nb_mismatched + 1;
									if l_nb_mismatched > fuzzy then
											-- Too many mismatched, so we stop
										j := l_pattern_count - 1	-- Jump out of loop
										l_matched := False
									end
								end
								j := j + 1
							end

							if l_matched then
									-- We got the substring
								Result := i - l_area_lower
								i := l_end_pos	-- Jump out of loop
							else
								if i + l_pattern_count <= end_pos then
										-- Pattern was not found, compute shift to next location
									from
										j := 0
										l_min_offset := l_pattern_count + 1
									until
										j > fuzzy
									loop
										l_char_code := code_or_foreign_code (
											i + l_pattern_count - j - 1, l_area, a_string, l_upper_place_holder
										)
										if l_char_code.to_integer_32 > max_code_point_value then
												-- No optimization for a characters above
												-- `max_code_point_value'.
											l_min_offset := 1
											j := fuzzy + 1 -- Jump out of loop
										else
											l_min_offset := l_min_offset.min (l_deltas_array.item (j).item (l_char_code.to_integer_32))
										end
										j := j + 1
									end
									i := i + l_min_offset
								else
									i := i + 1
								end
							end
						end
					end
					deltas_array := Void
				end
			end
		end

feature {NONE} -- Implementation

	code_or_foreign_code (
		index: INTEGER; a_string_area: SPECIAL [CHARACTER]; a_string: like string_type; upper_place_holder: NATURAL
	): NATURAL
			-- code at index, or unicode if code is a place holder
		do
			Result := a_string_area.item (index).natural_32_code
			if Result <= upper_place_holder then
				Result := a_string.code (index + 1)
			end
		end

end