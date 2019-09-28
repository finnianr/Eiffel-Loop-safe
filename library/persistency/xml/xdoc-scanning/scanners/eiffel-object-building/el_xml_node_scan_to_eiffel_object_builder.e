note
	description: "Eiffel object builder from XML/Pyxix node scanning source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 17:39:15 GMT (Sunday 28th October 2018)"
	revision: "3"

class
	EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER

inherit
	EL_XML_NODE_SCAN_SOURCE
		rename
			seed_object as target,
			set_seed_object as set_target
		redefine
			make_default, set_target, target
		end

create
	make

feature {NONE}  -- Initialisation

	make_default
		do
			create context_stack.make (20)
			Precursor
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
		end

	on_start_document
			--
		do
		end

	on_end_document
			--
		do
			context_stack.wipe_out
		end

	on_start_tag
			--
		local
			current_index: INTEGER
		do
			context_stack.item.add_xpath_step (last_node.xpath_name)
			context_stack.item.set_node (last_node)
			context_stack.item.do_with_xpath

			if context_stack.item.has_next_context then
				change_context (context_stack.item.next_context)
			end
			from attribute_list.start until attribute_list.after loop
				apply_building_action_for_node (attribute_list.node)

				if context_stack.item.has_next_context then
					change_context (context_stack.item.next_context)

					current_index := attribute_list.index
					from attribute_list.start until attribute_list.after loop
						if attribute_list.index /= current_index then
							apply_building_action_for_node (attribute_list.node)
						end
						attribute_list.forth
					end
					attribute_list.go_i_th (current_index)
				end
				attribute_list.forth
			end
		end

	on_end_tag
			--
		local
			popped_context: EL_EIF_OBJ_XPATH_CONTEXT
		do
			if not context_stack.item.is_xpath_prunable then
				popped_context := context_stack.item
				context_stack.remove
				popped_context.on_context_exit
				context_stack.item.on_context_return (popped_context)
			end
			context_stack.item.remove_xpath_step
		end

	on_content
			--
		do
			apply_building_action_for_node (last_node)
		end

	on_comment
			--
		do
			apply_building_action_for_node (last_node)
		end

	on_processing_instruction
			--
		do
			apply_building_action_for_node (last_node)
		end

feature -- Element change

	set_target (a_target: like target)
			-- set object to build
		local
			root_context: EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
		do
			Precursor (a_target)
			target.set_node (last_node)

			root_context := target.root_builder_context
			root_context.set_node (last_node)
			root_context.set_target (target)
			context_stack.extend (root_context)
		end

feature {NONE} -- Implementation

	change_context (new_context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			context_stack.item.delete_next_context
			context_stack.extend (new_context)
		end

	apply_building_action_for_node (node: EL_XML_NODE)
			--
		do
			context_stack.item.set_node (node)
			context_stack.item.add_xpath_step (node.xpath_name)
			context_stack.item.do_with_xpath
			context_stack.item.remove_xpath_step
		end

	context_stack: ARRAYED_STACK [EL_EIF_OBJ_XPATH_CONTEXT]

	target: EL_BUILDABLE_FROM_NODE_SCAN
		-- target object to build from XML node scan

end
