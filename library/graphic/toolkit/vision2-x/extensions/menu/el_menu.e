note
	description: "[
		Application menu with optional localization via class [$source EL_MODULE_LOCALE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-13 10:09:52 GMT (Saturday 13th July 2019)"
	revision: "7"

deferred class
	EL_MENU

inherit
	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_LOG

	EL_MODULE_SCREEN

	EV_KEY_CONSTANTS
		export
			{NONE} all
		end

	EL_KEY_MODIFIER_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_window: like window)
		require
			has_menu_bar: attached a_window.menu_bar
		do
			window := a_window
			create internal_menu.make_with_container_at_position (container, agent new_menu, position)
			create keyboard_shortcuts.make (window)
			create shortcut_descriptions.make (11)

			fill; add_keyboard_shortcuts; adjust_menu_texts
			is_menu_sensitive := True
		end

feature -- Access

	item (id: INTEGER): EV_MENU_ITEM
		require
			valid_id: is_valid_id (id)
		do
			if attached {EV_MENU_ITEM} menu.retrieve_item_by_data (id, True) as l_result then
				Result := l_result
			else
				create Result.make_with_text ("Invalid item")
			end
		end

	menu: like internal_menu.item
		do
			Result := internal_menu.item
		end

	name: ZSTRING
		do
			Result := Locale * eng_name
		end

feature -- Basic operations

	update
		do
			internal_menu.update -- Replaces menu_bar menu with new one
			fill; adjust_menu_texts; adjust_items_sensitivity
		end

feature -- Element change

	add_identified_item (id: INTEGER; a_name: READABLE_STRING_GENERAL; action: like Type_menu_action)
		local
			l_item: like new_item
		do
			l_item := new_item (a_name, action)
			l_item.set_data (id)
			menu.extend (l_item)
		ensure
			is_valid_id (id)
		end

	add_identified_sub_menu (id: INTEGER; sub_menu: EL_MENU)
		do
			sub_menu.menu.set_data (id)
		end

	add_item (a_name: READABLE_STRING_GENERAL; action: like Type_menu_action)
		do
			menu.extend (new_item (a_name, action))
		end

	add_separator
		do
			menu.extend (create {EV_MENU_SEPARATOR})
		end

feature -- Status change

	adjust_items_sensitivity
			-- override to adjust menu items sensitivity for current application state
			-- (automatically added to menu select_actions and called before each shortcut key action)
		do
		end

	disable_all_items_sensitive
		do
			apply_action_all (agent internal_disable_sensitive)
		end

	disable_item_sensitive (id: INTEGER)
		do
			disable_items_sensitive (<< id >>)
		end

	disable_items_sensitive (selected_ids: ARRAY [INTEGER])
		do
			apply_action (agent internal_disable_sensitive, selected_ids)
		end

	disable_sensitive
		do
			menu.disable_sensitive
			is_menu_sensitive := False
		end

	enable_all_items_sensitive
		do
			apply_action_all (agent internal_enable_sensitive)
		end

	enable_item_sensitive (id: INTEGER)
		do
			enable_items_sensitive (<< id >>)
		end

	enable_items_sensitive (selected_ids: ARRAY [INTEGER])
		do
			apply_action (agent internal_enable_sensitive, selected_ids)
		end

	enable_sensitive
		do
			menu.enable_sensitive
			is_menu_sensitive := True
		end

	set_item_sensitivity (id: INTEGER; sensitive: BOOLEAN)
		require
			is_valid_id (id)
		do
			if sensitive then
				internal_enable_sensitive (item (id))
			else
				internal_disable_sensitive (item (id))
			end
		end

feature -- Status query

	is_menu_sensitive: BOOLEAN

	is_valid_id (id: INTEGER): BOOLEAN
		do
			Result := attached {EV_MENU_ITEM} menu.retrieve_item_by_data (id, True)
		end

feature -- Basic operations

	apply_action (action: PROCEDURE [EV_MENU_ITEM]; selected_ids: ARRAY [INTEGER])
			-- applies action to all menu items identified by selected_ids
		do
			across selected_ids as id loop
				action.call ([item (id.item)])
			end
		end

	apply_action_all (action: PROCEDURE [EV_MENU_ITEM])
			-- applies action to all menu items
		do
			across menu as menu_item loop
				action.call ([menu_item.item])
			end
		end

feature {NONE} -- Factory

	new_item (a_name: READABLE_STRING_GENERAL; action: like Type_menu_action): EV_MENU_ITEM
		do
			create Result.make_with_text_and_action (a_name.to_string_32, action)
		end

	new_menu: like menu
		do
			create Result.make_with_text (name.to_unicode)
			Result.select_actions.extend (agent adjust_items_sensitivity)
		end

	new_shortcut_description (key_code: INTEGER; combined_modifiers: NATURAL): ZSTRING
			-- Eg. Ctrl+Shift+Delete
		local
			key_string: STRING_32
		do
			create Result.make (8)
			across Modifier_list as modifer loop
				if (combined_modifiers & modifer.item.code).to_boolean then
					if not Result.is_empty then
						Result.append_character ('+')
					end
					Result.append (modifer.item.name)
				end
			end
			if not Result.is_empty then
				Result.append_character ('+')
			end
			key_string := Key_strings [key_code]
			if key_string.count = 1 then
				Result.append_string_general (key_string.as_upper)
			else
				Result.append (Locale * Key_template #$ [key_string])
			end
		end

feature {NONE} -- Event handler

	on_keyboard_shortcut (select_actions: EV_NOTIFY_ACTION_SEQUENCE)
		local

		do
			adjust_items_sensitivity
			if is_menu_sensitive and then select_actions.state /= select_actions.Blocked_state then
				select_actions.call ([])
			end
		end

feature {NONE} -- Implementation

	add_keyboard_shortcuts
		do
		end

	add_shortcut (id, key_code: INTEGER; combined_key_modifiers: NATURAL)
			-- add keyboard shortcut with modifiers combined with logical OR
		require
			valid_id: is_valid_id (id)
		do
			keyboard_shortcuts.add_key_action (
				key_code, agent on_keyboard_shortcut (item (id).select_actions), combined_key_modifiers
			)
			shortcut_descriptions [id] :=  new_shortcut_description (key_code, combined_key_modifiers)
		end

	adjust_menu_item_text (menu_item: EV_MENU_ITEM)
		local
			adjusted_text: ZSTRING
		do
			if not attached {EV_MENU_SEPARATOR} menu_item then
				adjusted_text := menu_item.text
				if attached {INTEGER} menu_item.data as id then
					if shortcut_descriptions.has_key (id) then
						adjusted_text.append_character ('%T')
						adjusted_text.append (shortcut_descriptions.found_item)
					end
				end
				menu_item.set_text (adjusted_text.to_unicode)
			end
		end

	adjust_menu_texts
			-- adjust menu texts to include shortcut information and extra space for Windows Aero themes
		do
			menu.do_all (agent adjust_menu_item_text)
		end

	call (object: ANY)
		do
		end

	container: EV_DYNAMIC_LIST [EV_CONTAINABLE]
		do
			Result := window.menu_bar
		end

	eng_name: READABLE_STRING_GENERAL
		deferred
		end

	fill
		deferred
		end

	internal_disable_sensitive (menu_item: EV_MENU_ITEM)
		do
			menu_item.disable_sensitive
			menu_item.select_actions.block
		end

	internal_enable_sensitive (menu_item: EV_MENU_ITEM)
		do
			menu_item.enable_sensitive
			menu_item.select_actions.resume
		end

	position: INTEGER
		-- position at which to enter menu
		-- if 0 then extend menu_bar
		do
		end

feature {NONE} -- Internal attributes

	internal_menu: EL_MANAGED_CONTAINABLE [EV_MENU]

	keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS

	shortcut_descriptions: HASH_TABLE [ZSTRING, INTEGER]
		-- keyboard shortcuts info indexed by menu item id

	window: EV_WINDOW

feature {NONE} -- Type definitions

	Modifier_list: ARRAY [TUPLE [code: NATURAL; name: ZSTRING]]
		once
			Result := <<
				[Modifier_ctrl, Locale * "Ctrl"], [Modifier_alt, Locale * "Alt"], [Modifier_shift, Locale * "Shift"]
			>>
		end

	Type_menu_action: PROCEDURE
		require
			never_called: False
		do
		end

feature {NONE} -- Constants

	Key_template: ZSTRING
		once
			Result := "{key-%S}"
		end

end
