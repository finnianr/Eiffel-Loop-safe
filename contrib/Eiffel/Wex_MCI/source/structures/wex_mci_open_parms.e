indexing
	description: "This class represents the MCI_OPEN_PARMS structure."
	status: "See notice at end of class."
	author: "Robin van Ommeren"
	date: "$Date: 1998/07/22 19:55:29 $"
	revision: "$Revision: 1.1 $"

class
	WEX_MCI_OPEN_PARMS

inherit
	WEX_MCI_GENERIC_PARMS
		rename
			make as generic_make
		redefine
			structure_size
		end

creation
	make,
	make_by_pointer

feature -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW; a_device: STRING) is
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
			a_device_not_void: a_device /= Void
--			WEXCHANGE
			a_device_not_empty: not a_device.is_empty
		do
			if not exists then
				structure_make
			end
			generic_make (a_parent)
			set_device_type (a_device)
		ensure
			exists: exists
		end

feature -- Status report

	device_id: INTEGER is
			-- Id of the openend device.
		require
			exists: exists
		do
			Result := cwex_mci_open_get_device (item)
		end

feature -- Status setting

	set_device_type (type: STRING) is
		require
			exists: exists
			type_not_void: type /= Void
--			WEXCHANGE
			type_not_empty: not type.is_empty
		do
			create device_type.make (type)
			cwex_mci_open_set_device_type (item, device_type.item)
		end

	set_element_name (element: STRING) is
			-- Set the filename to be opened.
		require
			exists: exists
			element_not_void: element /= Void
--			WEXCHANGE
--			element_not_empty: not element.is_empty
		do
			create element_name.make (element)
			cwex_mci_open_set_element_name (item, element_name.item)
		end

	set_alias (a_alias: STRING) is
			-- Set the filename to be opened.
		require
			exists: exists
			a_alias_not_void: a_alias /= Void
--			WEXCHANGE
			a_alias_not_empty: not a_alias.is_empty
		do
			create mci_alias.make (a_alias)
			cwex_mci_open_set_alias (item, mci_alias.item)
		end

feature {WEL_STRUCTURE}

	structure_size: INTEGER is
			-- Size to allocate (in bytes)
		once
			Result := c_size_of_mci_open_parms
		end
		
	element_name: WEL_STRING
	
	device_type: WEL_STRING
	
	mci_alias: WEL_STRING


feature {NONE} -- Externals

	c_size_of_mci_open_parms: INTEGER is
		external
			"C [macro <open.h>]"
		alias
			"sizeof (MCI_OPEN_PARMS)"
		end

	cwex_mci_open_set_device_type (ptr, value: POINTER) is
		external
			"C [macro <open.h>]"
		end

	cwex_mci_open_set_element_name (ptr, value: POINTER) is
		external
			"C [macro <open.h>]"
		end

	cwex_mci_open_set_alias (ptr, value: POINTER) is
		external
			"C [macro <open.h>]"
		end

	cwex_mci_open_get_device (ptr: POINTER): INTEGER is
		external
			"C [macro <open.h>]"
		end

end -- class WEX_MCI_OPEN_PARMS

--|-------------------------------------------------------------------------
--| WEX, Windows Eiffel library eXtension
--| Copyright (C) 1998  Robin van Ommeren, Andreas Leitner
--| See the file forum.txt included in this package for licensing info.
--|
--| Comments, Questions, Additions to this library? please contact:
--|
--| Robin van Ommeren						Andreas Leitner
--| Eikenlaan 54M								Arndtgasse 1/3/5
--| 7151 WT Eibergen							8010 Graz
--| The Netherlands							Austria
--| email: robin.van.ommeren@wxs.nl		email: andreas.leitner@teleweb.at
--| web: http://home.wxs.nl/~rommeren	web: about:blank
--|-------------------------------------------------------------------------
