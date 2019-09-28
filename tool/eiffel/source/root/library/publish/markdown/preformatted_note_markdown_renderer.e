note
	description: "Preformatted note markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	PREFORMATTED_NOTE_MARKDOWN_RENDERER

inherit
	NOTE_MARKDOWN_RENDERER
		redefine
			Markup_substitutions
		end

create
	default_create

feature {NONE} -- Constants

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make (1)
			Result.extend (new_hyperlink_substitution ("[$source"))
		end

end
