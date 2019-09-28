note
	description: "Mono unitized sample file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MONO_UNITIZED_SAMPLE_FILE

inherit
	RAW_FILE
		rename
			extend as extend_character,
			last_double as last_sample
		export
			{NONE} all
			{ANY} close, delete, is_open_read, read_real, last_sample, open_read
		end

create
	make_open_write, make_open_read

feature -- Element change

	extend (v: DOUBLE)
			-- Include `v' at end.
		do
			put_double (v)
			maximum := maximum.max (v.abs)
			sample_count := sample_count + 1
		end

feature -- Access

	sample_count: INTEGER

	maximum: DOUBLE

	last_normalised_sample: DOUBLE
			--
		do
			Result := last_sample / maximum
		end

end