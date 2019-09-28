note
	description: "Model world tiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	MODEL_WORLD_TILER

feature -- Basic operations

	add_tiles (pixmap: EV_PIXMAP)
			--
		local
			tile: EV_MODEL_PICTURE
			pos: EV_COORDINATE
		do
			create pos.make (0, 0)

			from pos.set_y (0) until pos.y + pixmap.height > model_cell.height loop

				from pos.set_x (0) until pos.x + pixmap.width > model_cell.width loop
					create tile.make_with_pixmap (pixmap)
					tile.set_point_position (pos.x, pos.y)

					model.extend (tile)
					model.send_to_back (tile)
					pos.set_x (pos.x + pixmap.width)
				end
				pos.set_y (pos.y + pixmap.height)
			end

		end

feature {NONE} -- Implementation

	model_cell: EV_MODEL_WORLD_CELL
			--
		deferred
		end

	model: EV_MODEL_WORLD
			--
		deferred
		end

end