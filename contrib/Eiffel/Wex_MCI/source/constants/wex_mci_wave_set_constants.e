indexing
	description: "Constants used for the MCI_SET command for %
		% the waveaudio MCI device."
	status: "See notice at end of class."
	author: "Robin van Ommeren"
	date: "$Date: 1998/07/22 19:55:28 $"
	revision: "$Revision: 1.1 $"

class
	WEX_MCI_WAVE_SET_CONSTANTS

feature -- Access

	Mci_wave_input: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_INPUT"
		end

	Mci_wave_output: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_OUTPUT"
		end

	Mci_wave_set_anyinput: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_ANYINPUT"
		end

	Mci_wave_set_anyoutput: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_ANYOUTPUT"
		end

	Mci_wave_set_formattag: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_FORMATTAG"
		end

	Mci_wave_set_avgbytespersec: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_AVGBYTESPERSEC"
		end

	Mci_wave_set_bitspersample: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_BITSPERSAMPLE"
		end

	Mci_wave_set_blockalign: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_BLOCKALIGN"
		end

	Mci_wave_set_channels: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_CHANNELS"
		end

	Mci_wave_set_samplespersec: INTEGER is
		external
			"C [macro <wex_mci.h>]"
		alias
			"MCI_WAVE_SET_SAMPLESPERSEC"
		end

end -- class WEX_MCI_WAVE_SET_CONSTANTS

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