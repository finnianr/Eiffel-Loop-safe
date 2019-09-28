note
	description: "Tab content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_TAB_CONTENT [W -> {EV_WINDOW}]

inherit
	EL_MODULE_DEFERRED_LOCALE

feature {EL_FIXED_TAB_BOOK} -- Initialization

	initialize
		deferred
		end

	make (a_tab_book: like tab_book)
		do
			tab_book := a_tab_book
			initialize
		end

feature -- Access

	border_cms: REAL
		deferred
		end

	padding_cms: REAL
		deferred
		end

	display_name: ZSTRING
		do
			Result := Locale * eng_name
		end

	eng_name: READABLE_STRING_GENERAL
		-- English name
		deferred
		end

feature {EL_NOTEBOOK_TAB} -- Factory

	new_box: EL_VERTICAL_BOX
			--
		do
			create Result.make_unexpanded (border_cms, padding_cms, new_widgets)
		end

	new_widgets: ARRAY [EV_WIDGET]
		deferred
		end

feature {NONE} -- Internal attributes

	window: W
		do
			Result := tab_book.window
		end

	tab_book: EL_FIXED_TAB_BOOK [W]

end
