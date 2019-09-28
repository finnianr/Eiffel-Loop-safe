note
	description: "[
		Updateable set of numbered file resources available in an installation directory
		and a user data directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:36:06 GMT (Monday 1st July 2019)"
	revision: "3"

class
	EL_UPDATEABLE_RESOURCE_SET

inherit
	EL_FILE_MANIFEST_LIST

	EL_MODULE_DIRECTORY

create
	make, make_standard

feature {NONE} -- Initialization

	make (installed_base_dir, updated_base_dir, relative_path: EL_DIR_PATH)
		local
			manifest_path: EL_FILE_PATH
		do
			installed_dir := installed_base_dir.joined_dir_path (relative_path)
			updated_dir := updated_base_dir.joined_dir_path (relative_path)
			manifest_path := new_item_path (Manifest_name)
			if manifest_path.exists then
				make_from_file (manifest_path)
			else
				make_empty
			end
		end

	make_standard (installed_base_dir, relative_path: EL_DIR_PATH)
		do
			make (installed_base_dir, Directory.app_configuration, relative_path)
		end

feature -- Access

	i_th_path (i: INTEGER): EL_FILE_PATH
		do
			if valid_index (i) then
				Result := new_item_path (i_th (i).name)
			else
				create Result
			end
		end

	installed_dir: EL_DIR_PATH
		-- directory for installed items

	item_path: EL_FILE_PATH
		do
			Result := new_item_path (item.name)
		end

	new_item_path (name: ZSTRING): EL_FILE_PATH
		do
			Result := updated_dir + name
			if not Result.exists then
				Result := installed_dir + name
			end
		end

	updated_dir: EL_DIR_PATH
		-- directory for updated items

feature {EL_RESOURCE_INSTALL_MANAGER} -- Constants

	Manifest_name: ZSTRING
		once
			Result := "manifest.xml"
		end

end
