note
	description: "Multimedia Extensions Window Messages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_MM_SYSTEM_CONSTANTS

feature -- Access

	MM_sys_err_noerror: INTEGER
			--
		once
			Result := cdef_mmsyserr_noerror
		end

	Wave_mapper: INTEGER
			--
		once
			Result := cdef_wave_mapper
		end

	Callback_window: INTEGER
			--
		once
			Result := cdef_callback_window
		end

	MM_wim_data: INTEGER
			--
		once
			Result := cdef_mm_wim_data
		end

	MM_wim_open: INTEGER
			--
		once
			Result := cdef_mm_wim_open
		end

	MM_wim_close: INTEGER
			--
		once
			Result := cdef_mm_wim_close
		end

feature {NONE} -- Implementation

	cdef_MM_WIM_DATA: INTEGER
			-- received waveform input data
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_DATA"
		end

	cdef_MM_WIM_OPEN: INTEGER
			-- waveform input opened
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_OPEN"
		end

	cdef_MM_WIM_CLOSE: INTEGER
			-- waveform input closes
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_CLOSE"
		end

	cdef_WHDR_PREPARED: INTEGER
			-- set if this header has been prepared
		external
			"C [macro <mmsystem.h>]"
		alias
			"WHDR_PREPARED"
		end

	cdef_WHDR_DONE: INTEGER
			-- set if this header has been prepared
		external
			"C [macro <mmsystem.h>]"
		alias
			"WHDR_DONE"
		end

	cdef_WAVE_MAPPER: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVE_MAPPER"
		end

	cdef_CALLBACK_WINDOW: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"CALLBACK_WINDOW"
		end

	cdef_CALLBACK_FUNCTION: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"CALLBACK_FUNCTION"
		end

	cdef_WAVE_FORMAT_PCM: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVE_FORMAT_PCM"
		end

feature -- Error codes

	cdef_MMSYSERR_NOERROR: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NOERROR"
		end

	cdef_WAVERR_STILLPLAYING: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVERR_STILLPLAYING"
		end

	cdef_MMSYSERR_INVALHANDLE: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_INVALHANDLE"
		end

	cdef_MMSYSERR_NODRIVER: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NODRIVER"
		end

	cdef_MMSYSERR_NOMEM: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NOMEM"
		end

end
