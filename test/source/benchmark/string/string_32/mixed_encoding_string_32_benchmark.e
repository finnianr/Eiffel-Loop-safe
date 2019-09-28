note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	MIXED_ENCODING_STRING_32_BENCHMARK

inherit
	STRING_32_BENCHMARK
		undefine
			do_performance_tests, do_memory_tests
		end

	MIXED_ENCODING_STRING_BENCHMARK
		undefine
			make
		end

create
	make

end