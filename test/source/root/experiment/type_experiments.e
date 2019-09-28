note
	description: "Type experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-13 15:20:04 GMT (Friday 13th September 2019)"
	revision: "2"

class
	TYPE_EXPERIMENTS

inherit
	EXPERIMENTAL

feature -- Basic operations

	conforming_types
		do
			if {ISE_RUNTIME}.type_conforms_to (
				({EL_STANDARD_UNINSTALL_APP}).type_id, ({EL_INSTALLABLE_SUB_APPLICATION}).type_id
				) then
				lio.put_line ("Conforms")
			end
		end

	create_aia_credential
		local
			key_pair: AIA_CREDENTIAL
		do
			key_pair := ({AIA_CREDENTIAL}).default
		end

	generic_type_check
		local
			list: LIST [STRING_GENERAL]
			type: TYPE [ANY]
		do
			create {EL_ZSTRING_LIST} list.make (0)
			type := list.generating_type.generic_parameter_type (1)
		end

	generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
		end

	id_comparison
		local
			list: ARRAYED_LIST [STRING]
			list_integer: ARRAYED_LIST [INTEGER]
		do
			create list.make (0)
			create list_integer.make (0)
			lio.put_integer_field ("type_id", ({ARRAYED_LIST [STRING]}).type_id)
			lio.put_integer_field (" dynamic_type", Eiffel.dynamic_type (list))
			lio.put_integer_field (" dynamic_type list_integer", Eiffel.dynamic_type (list_integer))
			lio.put_new_line
			lio.put_integer_field ("({EL_MAKEABLE_FROM_STRING [ZSTRING]}).type_id", ({EL_MAKEABLE_FROM_ZSTRING}).type_id)
			lio.put_new_line
			lio.put_integer_field ("({EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}).type_id", ({EL_MAKEABLE_FROM_STRING_GENERAL}).type_id)
		end
end
