note
	description: "Class to help integrate WEX with Vision2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

deferred class
	EL_WAVE_AUDIO_PLAYBACK

feature -- Access

	wave_device: EL_AUDIO_SEGMENT_PLAYING_DEVICE
			--
		once
			if attached {WEL_COMPOSITE_WINDOW} implementation as wel_window then
				-- Underlying toolkit window
				create Result.make (wel_window)
			end
		ensure
			created_result: Result /= Void
		end

feature -- Basic operations

	close_wave_device
			-- 
		do
			if wave_device.opened then
				wave_device.stop
				wave_device.close
			end
		end

feature {NONE} -- Implementation

	implementation: EV_WIDGET_I
			-- 
		deferred
		end

end