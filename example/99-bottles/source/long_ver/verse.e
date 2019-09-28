note
	description: "Song verse"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	VERSE

inherit
	LINKED_LIST [SENTENCE]
		export
			{NONE} last
		end

create
	make

feature -- Access

	last_sentence: SENTENCE
			--
		do
			if {sentence: SENTENCE} last then
				Result := sentence
			else
				create Result.make
			end
		end

feature -- Output

	print_to_medium (io_medium: IO_MEDIUM)
			--
		do
			do_all (agent {SENTENCE}.print_to_medium (io_medium))
			io_medium.put_new_line
		end

end -- class VERSE
