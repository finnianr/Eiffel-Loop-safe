note
	description: "Signal math proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	SIGNAL_MATH_PROXY

inherit
	SIGNAL_MATH_I

	EL_REMOTE_PROXY

create
	make

feature -- Access

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): COLUMN_VECTOR_COMPLEX_DOUBLE

			-- Processing instruction example:
   			-- 		<?call {SIGNAL_MATH}.cosine_waveform (4, 7, 0.5)?>
		do
			log.enter (R_cosine_waveform)
			call (R_cosine_waveform, [i_freq, log2_length, phase_fraction])

			if not has_error and then attached {like cosine_waveform} result_object as object then
				Result := object
			else
				create Result.make
			end
			log.exit
		end

feature {NONE} -- Routine names

	R_cosine_waveform: STRING = "cosine_waveform"

end
