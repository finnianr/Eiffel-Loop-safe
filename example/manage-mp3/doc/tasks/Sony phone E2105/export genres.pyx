pyxis-doc:
	version = 1.0; encoding = "UTF-8"

export_music_to_device:
	is_dry_run = false

	volume:
		name = "E2105"; destination_dir = "SD Card/Music"; id3_version = 2.3
	playlist_export:
		root = "/storage/sdcard1"; subdirectory_name = "playlists"
	
	selected_genres:
		item:
			"Blues"
			"Dance"
			"Classical (Bells)"
			"Classical (Choir)"
			"Foxtrot"
			"Polka"
			"Milonga"
			"Milonga (Electro)"
			"Tango"
			"Tango (Electro)"
			"Vals"

