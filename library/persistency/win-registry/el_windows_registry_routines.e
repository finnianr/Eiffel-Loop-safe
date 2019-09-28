note
	description: "Windows registry routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_WINDOWS_REGISTRY_ROUTINES

inherit
	EL_POINTER_ROUTINES

feature -- Access

	string (key_path: EL_DIR_PATH; key_name: ZSTRING): ZSTRING
		do
			Result := string_32 (key_path, key_name)
		end

	string_8 (key_path: EL_DIR_PATH; key_name: ZSTRING): STRING
		do
			Result := string_32 (key_path, key_name)
		end

	string_32 (key_path: EL_DIR_PATH; key_name: ZSTRING): STRING_32
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value
			then
				Result := value.string_value
			else
				create Result.make_empty
			end
		end

	string_list (key_path: EL_DIR_PATH): EL_REGISTRY_STRING_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	integer (key_path: EL_DIR_PATH; key_name: ZSTRING): INTEGER
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value then
				Result := value.dword_value
			end
		end

	integer_list (key_path: EL_DIR_PATH): EL_REGISTRY_INTEGER_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	data (key_path: EL_DIR_PATH; key_name: ZSTRING): MANAGED_POINTER
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value then
				Result := value.data
			else
				create Result.make (0)
			end
		end

	data_list (key_path: EL_DIR_PATH): EL_REGISTRY_RAW_DATA_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	key_names (key_path: EL_DIR_PATH): EL_REGISTRY_KEYS_ITERABLE
			-- list of keys under key_path
		do
			create Result.make (key_path)
		end

	value_names (key_path: EL_DIR_PATH): EL_REGISTRY_VALUE_NAMES_ITERABLE
			-- list of value names under key_path
		do
			create Result.make (key_path)
		end

feature -- Element change

	set_string (key_path: EL_DIR_PATH; name, value: ZSTRING)
		local
			registry_value: WEL_REGISTRY_KEY_VALUE
		do
			create registry_value.make ({WEL_REGISTRY_KEY_VALUE_TYPE}.Reg_sz, value.to_unicode)
			set_value (key_path, name, registry_value)
		end

	set_integer (key_path: EL_DIR_PATH; name: ZSTRING; value: INTEGER)
		do
			set_value (key_path, name, create {WEL_REGISTRY_KEY_VALUE}.make_with_dword_value (value))
		end

	set_binary_data (key_path: EL_DIR_PATH; name: ZSTRING; value: MANAGED_POINTER)
		local
			registry_value: WEL_REGISTRY_KEY_VALUE
		do
			create registry_value.make_with_data ({WEL_REGISTRY_KEY_VALUE_TYPE}.Reg_binary, value)
			set_value (key_path, name, registry_value)
		end

	set_value (key_path: EL_DIR_PATH; name: ZSTRING; value: WEL_REGISTRY_KEY_VALUE)
		do
			registry.save_key_value (key_path, name.to_unicode, value)
		end

feature -- Removal

	remove_key_value (key_path: EL_DIR_PATH; value_name: ZSTRING)
		local
			node_ptr: POINTER;
			l_registry: like registry
		do
			l_registry := registry
			node_ptr := l_registry.open_key_with_access (key_path, {WEL_REGISTRY_ACCESS_MODE}.Key_set_value)
			if is_attached (node_ptr) then
				l_registry.delete_value (node_ptr, value_name)
			end
		end

	remove_key (parent_path: EL_DIR_PATH; key_name: ZSTRING)
		local
			node_ptr: POINTER
			l_registry: like registry
		do
			l_registry := registry
			node_ptr := l_registry.open_key_with_access (parent_path, {WEL_REGISTRY_ACCESS_MODE}.Key_set_value)
			if is_attached (node_ptr) then
				l_registry.delete_key (node_ptr, key_name)
			end
		end

feature -- Status query

	has_key (parent_path: EL_DIR_PATH): BOOLEAN
		local
			node_ptr: POINTER
		do
			node_ptr := registry.open_key_with_access (parent_path, {WEL_REGISTRY_ACCESS_MODE}.Key_read)
			Result := is_attached (node_ptr)
		end

feature {NONE} -- Implementation

	key_value (key_path: EL_DIR_PATH; key_name: ZSTRING): detachable WEL_REGISTRY_KEY_VALUE
		do
			Result := registry.open_key_value (key_path, key_name)
		end

	registry: WEL_REGISTRY
			-- Do not use 'once'. Weird shit starts happening when using a shared instance
		do
			create Result
		end

end
