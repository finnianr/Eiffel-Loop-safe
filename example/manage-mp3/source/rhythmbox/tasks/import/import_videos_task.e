note
	description: "Import videos task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 7:21:00 GMT (Thursday 5th September 2019)"
	revision: "3"

class
	IMPORT_VIDEOS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	EL_MODULE_AUDIO_COMMAND

	EL_MODULE_TIME

	EL_MODULE_USER_INPUT

create
	make

feature -- Basic operations

	apply
			--
		local
			import_notes: like Video_import_notes; done: BOOLEAN
			song_count: INTEGER
		do
			lio.put_line ("VIDEO IMPORT NOTES")
			import_notes := Video_import_notes #$ [Video_extensions]
			across import_notes.lines as line loop
				lio.put_line (line.item)
			end
			song_count := Database.songs.count
			lio.put_new_line
			across Video_extensions.split (',') as extension loop
				across OS.file_list (Database.music_dir, "*." + extension.item) as video_path loop
					lio.put_path_field ("Found", video_path.item.relative_path (Database.music_dir))
					lio.put_new_line
					from done := False until done loop
						Database.extend (new_video_song (video_path.item))
						done := not video_contains_another_song
					end
					OS.delete_file (video_path.item)
				end
			end
			if Database.songs.count > song_count then
				Database.store_all
			end
		end

feature {NONE} -- Factory

	new_input_song_time (prompt: ZSTRING): TIME
		local
			time_str: STRING
		do
			time_str := User_input.line (prompt).to_string_8
			if not time_str.has ('.') then
				time_str.append (".000")
			end
			if Time.is_valid_fine (time_str) then
				create Result.make_from_string (time_str, Fine_time_format)
			else
				create Result.make_by_seconds (0)
			end
		end

	new_song_info_input (duration_time: TIME_DURATION; default_title, lead_artist: ZSTRING): like SONG_INFO
		local
			zero: DOUBLE
		do
			create Result
			Result.time_from := new_input_song_time ("From time")
			Result.time_to := new_input_song_time ("To time")
			if Result.time_to.fine_seconds ~ zero then
				Result.time_to := new_time (duration_time.fine_seconds_count)
			end
			Result.beats_per_minute := User_input.integer ("Post play silence (secs)")
			Result.title := User_input.line ("Title")
			if Result.title.is_empty then
				Result.title := default_title
			end
			Result.album_name := User_input.line ("Album name")
			if Result.album_name ~ Ditto then
				Result.album_name := last_album_name
				lio.put_labeled_string ("Using album name", last_album_name)
				lio.put_new_line
			elseif Result.album_name.is_empty then
				Result.album_name := lead_artist
			end
			last_album_name := Result.album_name
			Result.album_artists := User_input.line ("Album artists")
			Result.recording_year := User_input.integer ("Recording year")
		end

	new_time (fine_seconds: DOUBLE): TIME
		do
			create Result.make_by_fine_seconds (fine_seconds)
		end

	new_video_song (video_path: EL_FILE_PATH): RBOX_SONG
		local
			video_properties: like Audio_command.new_audio_properties
			video_to_mp3_command: like Audio_command.new_video_to_mp3
			genre_path, artist_path: EL_DIR_PATH; l_song_info: like SONG_INFO
			duration_time: TIME_DURATION
		do
			artist_path := video_path.parent; genre_path := artist_path.parent
			video_properties := Audio_command.new_audio_properties (video_path)
			l_song_info := new_song_info_input (video_properties.duration, video_path.base_sans_extension, artist_path.base)
			Result := Database.new_song
			Result.set_title (l_song_info.title)
			Result.set_artist (artist_path.base)
			Result.set_genre (genre_path.base)
			if l_song_info.recording_year > 0 then
				Result.set_recording_year (l_song_info.recording_year)
			end
			if Database.silence_intervals.valid_index (l_song_info.beats_per_minute) then
				Result.set_beats_per_minute (l_song_info.beats_per_minute)
			end
			Result.set_album (l_song_info.album_name)
			Result.set_album_artists (l_song_info.album_artists)
			Result.set_mp3_path (Result.unique_normalized_mp3_path)

			video_to_mp3_command := Audio_command.new_video_to_mp3 (video_path, Result.mp3_path)

			if l_song_info.time_from.seconds > 0
				or l_song_info.time_to.fine_seconds /~ video_properties.duration.fine_seconds_count
			then
				video_to_mp3_command.set_offset_time (l_song_info.time_from)
				duration_time := l_song_info.time_to.relative_duration (l_song_info.time_from)
				-- duration has extra 0.001 secs added to prevent rounding error below the required duration
				duration_time.fine_second_add (0.001)
				video_to_mp3_command.set_duration (duration_time)
				Result.set_duration (duration_time.fine_seconds_count.rounded)
			end
			if l_song_info.beats_per_minute > 0 then
				Result.set_beats_per_minute (l_song_info.beats_per_minute)
			end
			-- Increase bitrate by 64 for AAC -> MP3 conversion
			video_to_mp3_command.set_bit_rate (video_properties.standard_bit_rate + 64)
			lio.put_string ("Converting..")
			video_to_mp3_command.execute
			Result.save_id3_info
			lio.put_new_line
		end

feature {NONE} -- Implementation

	video_contains_another_song: BOOLEAN
		do
			lio.put_string ("Extract another song from this video (y/n): ")
			Result := User_input.entered_letter ('y')
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	last_album_name: ZSTRING

feature {NONE} -- Type definitions

	SONG_INFO: TUPLE [
		time_from, time_to: TIME; title, album_artists, album_name: ZSTRING
		recording_year, beats_per_minute: INTEGER
	]
		require
			never_called: False
		once
			create Result
		end

feature {NONE} -- Constants

	Ditto: ZSTRING
		once
			Result := "%""
		end

	Fine_time_format: STRING = "mi:ss.ff3"

	Video_extensions: STRING = "flv,m4a,m4v,mp4,mov"

	Video_import_notes: ZSTRING
			-- '#' is the same as '%S'
		once
			Result := "[
				Place videos (or m4a audio files) in genre/artist folder.
				Imports files with extensions: #.
				Leave blank fields for the default. Default artist is the parent directory name.
				To duplicate previous album name enter " (for ditto).
				Input offset times are in mm:ss[.xxx] form. If recording year is unknown, enter 0.
			]"
		end

end
