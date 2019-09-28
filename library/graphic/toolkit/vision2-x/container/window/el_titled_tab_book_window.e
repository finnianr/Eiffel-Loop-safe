note
	description: "Titled tab book window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:11:16 GMT (Monday 1st July 2019)"
	revision: "6"

class
	EL_TITLED_TAB_BOOK_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			make
		end

	EL_MODULE_SCREEN

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create main_container
			main_container.set_border_width (Screen.horizontal_pixels (Main_container_border_cms))
			tab_book := new_tab_book
			main_container.extend (tab_book)

			extend (main_container)
		end

feature -- Access

	tab_book: EL_DOCKED_TAB_BOOK

feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
		-- Main container (contains all widgets displayed in this window)

	new_tab_book: like tab_book
		do
			create Result.make (Current)
		end

feature {NONE} -- Constants

	Main_container_border_cms: REAL
		once
			if not has_wide_theme_border then
				Result := 0.07
			end
		end

end
