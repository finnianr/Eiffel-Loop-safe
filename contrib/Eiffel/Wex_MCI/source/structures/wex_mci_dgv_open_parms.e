indexing
	description: "This class represents the MCI_DGV_OPEN_PARMS structure."
	status: "See notice at end of class."
	author: "Robin van Ommeren"
	date: "$Date: 1998/07/22 19:55:29 $"
	revision: "$Revision: 1.1 $"

class
	WEX_MCI_DGV_OPEN_PARMS

inherit
	WEX_MCI_OPEN_PARMS
		rename
			make as open_make
		redefine
			structure_size
		end

creation
	make,
	make_by_pointer

feature -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW; a_device: STRING) is
			-- Create object and fill structure.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
			a_device_not_void: a_device /= Void
			a_device_not_empty: not a_device.empty
		do
			if not exists then
				structure_make
			end
			open_make (a_parent, a_device)
		ensure
			exists: exists
		end

feature -- Status_report

	open_style: INTEGER is
			-- Style to open.
		require
			exists: exists
		do
			Result := cwex_mci_dgv_open_get_dw_style (item)
		end

	parent_handle: POINTER is
			-- Handle of parent
		require
			exists: exists
		do
			Result := cwex_mci_dgv_open_get_hwnd_parent (item)
		end

feature -- Status setting

	set_open_style (a_value: INTEGER) is
			-- Set style to open.
		require
			exists: exists
		do
			cwex_mci_dgv_open_set_dw_style (item, a_value)
		ensure
			open_style_set: open_style = a_value
		end

	set_parent_handle (a_value: POINTER) is
			-- Set handle of parent.
		require
			exists: exists
		do
			cwex_mci_dgv_open_set_hwnd_parent (item, a_value)
		ensure
			parent_handle_set: parent_handle = a_value
		end

feature {WEL_STRUCTURE}

	structure_size: INTEGER is
			-- Size to allocate (in bytes)
		once
			Result := c_size_of_mci_dgv_open
		end

feature {NONE} -- Externals

	c_size_of_mci_dgv_open: INTEGER is
		external
			"C [macro <dgv_open.h>]"
		alias
			"sizeof (MCI_DGV_OPEN_PARMS)"
		end

	cwex_mci_dgv_open_get_dw_style (ptr: POINTER) : INTEGER is
		external
			"C [macro <dgv_open.h>]"
		alias
			"cwex_mci_dgv_open_get_dw_style"
		end

	cwex_mci_dgv_open_get_hwnd_parent (ptr: POINTER) : POINTER is
		external
			"C [macro <dgv_open.h>]"
		alias
			"cwex_mci_dgv_open_get_hwnd_parent"
		end

	cwex_mci_dgv_open_set_dw_style (ptr: POINTER; a_value: INTEGER) is
		external
			"c[macro <dgv_open.h>]"
		alias
			"cwex_mci_dgv_open_set_dw_style"
		end

	cwex_mci_dgv_open_set_hwnd_parent (ptr: POINTER; a_value: POINTER) is
		external
			"c[macro <dgv_open.h>]"
		alias
			"cwex_mci_dgv_open_set_hwnd_parent"
		end

end -- class WEX_MCI_DGV_OPEN_PARMS

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