note
	description: "Hash set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-06 11:18:10 GMT (Tuesday 6th August 2019)"
	revision: "7"

class
	EL_HASH_SET [G -> HASHABLE]

inherit
	HASH_TABLE [detachable G, detachable G]
		rename
			current_keys as to_array,
			disjoint as ht_disjoint,
			extend as ht_extend,
			extendible as ht_extendible,
			item as table_item,
			merge as ht_merge,
			prune as ht_prune,
			remove as prune,
			put as ht_put
		export
			{NONE} all
			{ANY} iteration_position, keys, ht_put, content, deleted_marks, capacity,
				deleted_item_position, has_default, item_position
			{ANY} has, has_key, found, found_item, search, count, indexes_map,
				 inserted, to_array, wipe_out, conflict, key_for_iteration, item_for_iteration
		undefine
			changeable_comparison_criterion
		end

	TRAVERSABLE_SUBSET [detachable G]
		rename
			item as item_for_iteration
		undefine
			is_equal, copy
		select
			put, has, extend, prune, extendible
		end

create
	make, make_equal, make_from_array

feature {NONE} -- Initialization

	make_from_array (set: ARRAY [G])
		do
			make_equal (set.count)
			across set as l loop
				ht_extend (l.item, l.item)
			end
		end

feature -- Element change

	extend, put (new: detachable G)
			--
		do
			ht_put (new, new)
		end

	remove
		do
			prune (key_for_iteration)
		end

feature -- Access

	index: INTEGER

	subset (is_member: PREDICATE [G]; inverse: BOOLEAN): like Current
		do
			if object_comparison then
				create Result.make_equal (count // 2)
			else
				create Result.make (count // 2)
			end
			from start until after loop
				check has_item: attached item_for_iteration as al_item then
					if inverse then
						if not is_member (al_item) then
							Result.put (al_item)
						end
					else
						if is_member (al_item) then
							Result.put (al_item)
						end
					end
				end
				forth
			end
		end

	subset_exclude (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, True)
		end

	subset_include (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, False)
		end

feature -- Duplication

	duplicate (n: INTEGER): EL_HASH_SET [G]
		do
			if object_comparison then
				create Result.make_equal (n)
			else
				create Result.make (n)
			end
			Result.copy (Current)
		end

feature -- Status query

	Extendible: BOOLEAN = True
		-- May new items be added?

feature {NONE} -- Implementation

	subset_strategy_selection (v: detachable G; other: TRAVERSABLE_SUBSET [G]): SUBSET_STRATEGY_HASHABLE [G]
			-- Strategy to calculate several subset features selected depending
			-- on the dynamic type of `v' and `other'
		do
			create Result
		end

end
