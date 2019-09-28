pyxis-doc:
	version = 1.0; encoding = "UTF-8"

fractal:
	background_image_path = "$HOME/Graphics/backgrounds/paper.jpg"
	border_percent = 2

	root:
		image_path = "$HOME/Graphics/Objects/matryoshka_doll.png"

	satellite:
		size_proportion = 0.7; displaced_radius_proportion = 1; relative_angle = 0
		rotate:
			angle = 45
	satellite:
		size_proportion = 0.5; displaced_radius_proportion = 1; relative_angle = 90
	satellite:
		size_proportion = 0.7; displaced_radius_proportion = 1; relative_angle = 180
		rotate:
			angle = -45


