﻿note
	description: "Adds registry entry to prevent browser emulation mode of early IE version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:40:47 GMT (Wednesday 30th March 2016)"
	revision: "1"

class
	EL_WEB_BROWSER_INSTALLER

inherit
	ANY
	
	EL_MODULE_WIN_REGISTRY

	EL_MODULE_REG_KEY

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Basic operations

	install
		do
			Win_registry.set_integer (
				HKLM_IE_feature_browser_emulation, Execution.executable_name, Internet_explorer_major_version * 1000 + 1
			)
		end

	uninstall
		do
			Win_registry.remove_key_value (HKLM_IE_feature_browser_emulation, Execution.executable_name)
		end

feature {NONE} -- Constants

	Internet_explorer_major_version: INTEGER
		local
			version: ZSTRING
		once
			across << "svcVersion", "Version" >> as key_name until Result > 0 loop
				version := Win_registry.string (Reg_key.Internet_explorer.path, key_name.item)
				if not version.is_empty then
					Result := version.split ('.').first.to_integer
				end
			end
		end

	HKLM_IE_feature_browser_emulation: EL_DIR_PATH
		once
			Result := Reg_key.Internet_explorer.sub_dir_path ("MAIN\FeatureControl\FEATURE_BROWSER_EMULATION")
		end

end
