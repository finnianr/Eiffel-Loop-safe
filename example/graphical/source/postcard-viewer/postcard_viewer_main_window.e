note
	description: "Postcard viewer main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:12:16 GMT (Monday 1st July 2019)"
	revision: "4"

class
	POSTCARD_VIEWER_MAIN_WINDOW

inherit
	EL_TITLED_TAB_BOOK_WINDOW
		redefine
			make
		end

	SD_ACCESS
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_LOG

	EL_MODULE_GUI

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			create album_list.make
			album_list.compare_objects

			Precursor

			create address_bar.make (agent on_open_album)
			tab_book.add_toolbar (address_bar)

			set_title (Window_title)
				-- Set the initial size of the window
			set_size (Window_width, Window_height)

--			show_actions.extend (agent on_show)
		end

feature -- Status query

	is_main_container_set: BOOLEAN

feature {NONE} -- Events

	on_open_album
		local
			viewer: POSTCARD_VIEWER_TAB
		do
			create viewer.make (address_bar.location)
			tab_book.extend (viewer)

--			if attached {SD_TAB_ZONE} docking_manager.zones.zones.first as zone then
--				h1 := zone.title_area.height
--			end
		end

	on_show
		do
--			set_size (width * 4 // 5, height * 4 // 5)
--			restore
		end

feature {NONE} -- Implementation

	address_bar: ADDRESS_BAR

	album_list: LINKED_LIST [STRING]

feature {NONE} -- Constants

	Window_title: STRING = "Postcard Viewer"
			-- Title of the window.

	Window_width: INTEGER = 1200
			-- Initial width for this window.

	Window_height: INTEGER = 1000
			-- Initial height for this window.

	SD_colors: SD_COLORS
		once
			create Result.make
		end

end
