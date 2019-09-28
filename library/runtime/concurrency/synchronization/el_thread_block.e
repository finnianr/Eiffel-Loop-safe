note
	description: "Thread block"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_THREAD_BLOCK

inherit
	DISPOSABLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create mutex.make
			create condition.make
		end

feature -- Basic operations

	suspend
			--
		do
			mutex.lock
			condition.wait (mutex)
			mutex.unlock
		end

	resume
			--
		do
			condition.signal
		end

feature {NONE} -- Implementation

	dispose
			--
		do
			mutex.destroy
			condition.destroy
		end

	condition: CONDITION_VARIABLE

	mutex: MUTEX

end