pyxis-doc:
	version = 1.0; encoding = "UTF-8"

fractal:
	background_image_path = "$HOME/Graphics/backgrounds/paper.jpg"
	border_percent = 2

	root:
		image_path = "$HOME/Graphics/Objects/polished-turquoise.png"

	satellite:
		size_proportion = 0.7; displaced_radius_proportion = 1; relative_angle = 0
		mirror:
			axis = Y
		rotate:
			angle = 45

	satellite:
		size_proportion = 0.7; displaced_radius_proportion = 1; relative_angle = 90
		mirror:
			axis = X

	satellite:
		size_proportion = 0.7; displaced_radius_proportion = 1; relative_angle = 180
		rotate:
			angle = -45

