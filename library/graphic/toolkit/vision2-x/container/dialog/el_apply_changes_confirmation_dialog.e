note
	description: "Apply changes confirmation dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_APPLY_CHANGES_CONFIRMATION_DIALOG

inherit
	EL_CONFIRMATION_DIALOG
		rename
			ev_cancel as Eng_discard,
			ev_ok as Eng_apply
		redefine
			Eng_apply, Eng_discard
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	Eng_apply: STRING
			--
		once
			Result := "Apply"
		end

	Eng_discard: STRING
			--
		once
			Result := "Discard"
		end
end
