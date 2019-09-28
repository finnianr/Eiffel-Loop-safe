note
	description: "Screen imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_SCREEN_IMP

inherit
	EL_SCREEN_I
		undefine
			widget_at_mouse_pointer, virtual_width, virtual_height, virtual_x, virtual_y,
			monitor_count, monitor_area_from_position, refresh_graphics_context,
			working_area_from_window, working_area_from_position, monitor_area_from_window
		redefine
			interface
		end

	EV_SCREEN_IMP
		redefine
			interface
		end

	EL_SHARED_USEABLE_SCREEN

create
	make

feature -- Access

	useable_area: EV_RECTANGLE
			-- useable area not obscured by taskbar
		do
			Result := Useable_screen.area
		end

	widget_pixel_color (a_widget: EV_WIDGET_IMP; a_x, a_y: INTEGER): EV_COLOR
			--
		local
			l_rect, gdkpix: POINTER
			l_pixmap: EV_PIXMAP
			l_pixel_buffer: EV_PIXEL_BUFFER_IMP
			l_result: EL_COLOR
		do
			l_rect := app_implementation.reusable_rectangle_struct
			{GTK2}.set_gdk_rectangle_struct_width (l_rect, 1); {GTK2}.set_gdk_rectangle_struct_height (l_rect, 1)
			{GTK2}.set_gdk_rectangle_struct_x (l_rect, a_x); {GTK2}.set_gdk_rectangle_struct_y  (l_rect, a_y)
			create l_pixmap
			gdkpix := {EL_GTK2}.widget_get_snapshot (a_widget.c_object, l_rect)
			check attached {EV_PIXMAP_IMP} l_pixmap.implementation as pixmap_imp then
				pixmap_imp.copy_from_gdk_data (gdkpix, a_widget.NULL, 1, 1)
			end
			{GTK}.gdk_pixmap_unref (gdkpix)
			create l_pixel_buffer.make; l_pixel_buffer.make_with_pixmap (l_pixmap)
			create Result
			create l_result.make_with_rgb_24_bit ((l_pixel_buffer.get_pixel (0, 0) |>> 8).to_integer_32)
			Result := l_result
		end

feature -- Measurement

	height_mm: INTEGER
		do
			Result := X11_display.height_mm
		end

	width_mm: INTEGER
		do
			Result := X11_display.width_mm
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_SCREEN note option: stable attribute end;

feature {NONE} -- Constants

	X11_display: EL_X11_DISPLAY_OUTPUT_INFO
		local
			resources: EL_X11_SCREEN_RESOURCES_CURRENT
		once
			create resources.make
			Result := resources.connected_output_info
		end

end
