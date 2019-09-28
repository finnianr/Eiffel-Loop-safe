note
	description: "Cpp object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_CPP_OBJECT

inherit
	EL_DISPOSEABLE
		export
			{NONE} all
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make_from_pointer (cpp_ptr: POINTER)
			--
		require
			valid_object: is_attached (cpp_ptr)
		do
			self_ptr := cpp_ptr
		end

feature {EL_CPP_ITERATOR} -- Implementation

	is_memory_owned: BOOLEAN
			--
		do
			Result := false
		end

	dispose
			--
		do
			if is_memory_owned and then is_attached (self_ptr) then
				cpp_delete (self_ptr)
				self_ptr := Default_pointer
			end
		end

	cpp_delete (this: POINTER)
			--
		do
		end

	self_ptr: POINTER

end
