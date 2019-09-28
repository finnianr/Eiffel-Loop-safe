note
	description: "Java function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	JAVA_FUNCTION [
		BASE_TYPE -> JAVA_OBJECT_REFERENCE,
		RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_method_result end
	]

inherit
	JAVA_ROUTINE [BASE_TYPE]

create
	make

feature -- Access

	item (target: BASE_TYPE; args: TUPLE): RESULT_TYPE
			--
		require
			valid_operands: valid_operands (args)
		do
			java_args.put_java_tuple (args)
			create Result.make_from_java_method_result (target, method_id, java_args)
		end

feature {NONE} -- Implementation

	return_type_signature: STRING
			-- Routines return type void
		local
			sample_result: RESULT_TYPE
		do
			create sample_result
			Result := sample_result.Jni_type_signature
		end

end -- class JAVA_FUNCTION