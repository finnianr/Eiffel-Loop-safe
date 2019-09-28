note
	description: "Rbox application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 15:45:57 GMT (Sunday 1st September 2019)"
	revision: "9"

deferred class	RBOX_APPLICATION obsolete "Rewrite descendants using music manager task"

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION

	EL_ARGUMENT_TO_ATTRIBUTE_SETTING

	EL_MODULE_AUDIO_COMMAND

	EL_MODULE_OS

	RHYTHMBOX_CONSTANTS

	SONG_QUERY_CONDITIONS

feature {NONE} -- Initialization

	create_database
			--
		local
			playlist_path: EL_FILE_PATH; music_dir: EL_DIR_PATH
--			test_database_dir_abs: EL_DIR_PATH
			song: RBOX_SONG; l_duration: INTEGER; modification_time: DATE_TIME
		do
			log.enter ("create_database")
			if Is_test_mode then
				create modification_time.make (2011, 11, 11, 11, 11, 11)
				xml_database_path := test_database_dir + "rhythmdb.xml"
--				test_database_dir_abs := Directory.joined_path (Directory.current_working_directory, test_database_dir)

				substitute_work_area_variable (test_database_dir, xml_database_path)

				playlist_path := xml_database_path.parent + "playlists.xml"
				substitute_work_area_variable (test_database_dir, playlist_path)

				create database.make (xml_database_path, xml_database_path.parent.joined_dir_path ("Music"))

				if not (test_database_dir + "Music").exists then
					across database.songs as l_song loop
						song := l_song.item
						if not song.is_hidden then
							l_duration := song.duration
							if l_duration > 10 then
								l_duration := l_duration // 10
							end
							File_system.make_directory (song.mp3_path.parent)
							OS.copy_file (cached_song_file_path (song, l_duration), song.mp3_path)
						end
					end
				end
				database.update_index_by_audio_id
			else
				music_dir := "$HOME/Music"; music_dir.expand
				create database.make (xml_database_path, music_dir)
			end
			log.exit
		end

	normal_initialize
			--
		local
			config_file_path: EL_FILE_PATH
		do
			create {EL_WAV_GENERATION_COMMAND_IMP} test_wav_generator.make ("")
			create random.make

			create conditions.make (0)

			xml_database_path := User_config_dir + "rhythmdb.xml"
			set_attribute_from_command_opt (xml_database_path, "rhythmdb-file", "Path to Rhythmbox database: rhythmdb.xml")

			create config_file_path
			set_attribute_from_command_opt (config_file_path, "config", "Configuration file path")

			if config_file_path.is_empty then
				create config.make_default
			else
				create config.make (config_file_path)
			end

			if config.is_dry_run then
				config.volume.set_name ("Desktop/Music")
			end
			if not (Is_test_mode or command_line_help_option_exists) then
				get_user_input
			end
		end

feature -- Element change

	set_song_artist (song: RBOX_SONG; artist: STRING)
			--
		do
			song.set_artist (artist)
		end

	set_song_genre (song: RBOX_SONG; genre: STRING)
			--
		do
			song.set_genre (genre)
		end

feature {NONE} -- Implementation

	cached_song_file_path (song: RBOX_SONG; a_duration: INTEGER): EL_FILE_PATH
			-- Path to auto generated mp3 file under build directory
		require
			valid_duration: a_duration > 0
		local
			mp3_writer: like Audio_command.new_wav_to_mp3
			relative_steps: EL_PATH_STEPS
			wav_path: EL_FILE_PATH
			id3_info: EL_ID3_INFO
		do
			log.put_path_field ("Reading", song.mp3_path)
			log.put_new_line

			relative_steps := song.mp3_path.relative_path (database.music_dir).steps
			Result := Directory.new_path ("build").joined_file_steps (relative_steps)
			if not Result.exists then
				File_system.make_directory (Result.parent)
				wav_path := Result.with_new_extension ("wav")

				-- Create a unique random wav file
				test_wav_generator.set_output_file_path (wav_path)
				test_wav_generator.set_frequency_lower (100 + (200 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_frequency_upper (600  + (600 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_cycles_per_sec ((1.0 + random.real_item.to_double).truncated_to_real)
				random.forth

				if a_duration > 0 then
					test_wav_generator.set_duration (a_duration * 1000)
				end
				test_wav_generator.execute

				mp3_writer := Audio_command.new_wav_to_mp3 (wav_path, Result)
				mp3_writer.set_bit_rate_per_channel (48)
				mp3_writer.set_num_channels (1)
				mp3_writer.execute
				File_system.remove_file (wav_path)

				create id3_info.make (wav_path.with_new_extension ("mp3"))
				song.write_id3_info (id3_info)

			end
		ensure
			file_exists: Result.exists
		end

	get_user_input
		do
		end

	playlists_xml_path: EL_FILE_PATH
		do
			Result := xml_database_path.parent + "playlists.xml"
		end

	substitute_work_area_variable (data_path: EL_DIR_PATH; xml_file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			xml_text: STRING
		do
			xml_text := File_system.plain_text (xml_file_path)
			xml_text.replace_substring_all ("$WORKAREA", data_path.to_string.to_latin_1)

			create xml_file.make_open_write (xml_file_path)
			xml_file.put_string (xml_text)
			xml_file.close
		end

feature {NONE} -- Implementation: attributes

	conditions: ARRAYED_LIST [like predicate]

	config: TASK_CONFIG

	database: RBOX_DATABASE

	random: RANDOM

	test_database_dir: EL_DIR_PATH

	test_wav_generator: EL_WAV_GENERATION_COMMAND_I

	xml_database_path: EL_FILE_PATH

end
