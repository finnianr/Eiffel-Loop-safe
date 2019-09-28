note
	description: "Rhythmbox playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-17 9:14:19 GMT (Tuesday   17th   September   2019)"
	revision: "16"

class
	RBOX_PLAYLIST

inherit
	PLAYLIST
		rename
			make as make_playlist
		end

	MEDIA_ITEM
		rename
			relative_path as relative_m3u_path
		undefine
			is_equal, copy
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	M3U_PLAY_LIST_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_MODULE_URL

	EL_MODULE_UTF

	EL_MODULE_LOG

	EL_MODULE_DIGEST

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			make_default
			set_name (a_name)
		end

	make_default
		do
			make_playlist (10)
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			set_name (Empty_string)
		end

feature -- Access

	m3u_entry_list (is_windows_format, is_nokia_phone: BOOLEAN): EL_ZSTRING_LIST
		-- entry list with insert silences when song has not enough trailing silence
		local
			tanda_index: INTEGER
		do
			create Result.make (count)
			from start until after loop
				if not song.is_hidden then
					if song.is_cortina then
						tanda_index := tanda_index + 1
					end
					Result.extend (song.m3u_entry (tanda_index, is_windows_format, is_nokia_phone))
					if song.has_silence_specified then
						Result.extend (song.short_silence.m3u_entry (tanda_index, is_windows_format, is_nokia_phone))
					end
				end
				forth
			end
		end

	name: ZSTRING

	relative_m3u_path: EL_FILE_PATH
			-- Media item attribute
		do
			Result := Playlists_dir + name
			Result.add_extension (M3U_extension)
		end

feature -- Measurement

	checksum: NATURAL_32
			-- Media item attribute
		local
			crc: like crc_generator
		do
			crc := crc_generator
			from start until after loop
				crc.add_string (song.mp3_relative_path.to_string)
				if song.has_silence_specified then
					crc.add_integer (song.beats_per_minute)
				end
				forth
			end
			Result := crc.checksum
		end

	file_size_mb: DOUBLE
			-- Sum of size of m3u line (mega bytes)
		local
			summator: EL_CHAIN_SUMMATOR [ZSTRING, INTEGER]; bytes: INTEGER
		do
			create summator
			bytes := M3U.extm3u.count + summator.sum (m3u_entry_list (False, False), agent {ZSTRING}.count)
			Result := bytes / 1000000
		end

feature -- Status query

	is_name_dated: BOOLEAN
		local
			parts: EL_SPLIT_ZSTRING_LIST
		do
			create parts.make (name, character_string (' '))
			Result := parts.count > 1 and then parts.i_th (1).count = Date_format.count
							and then Date_checker.date_valid (parts.i_th (1), Date_format)
		end

feature -- Element change

	add_song_from_audio_id (a_audio_id: EL_UUID)
		do
			log.enter_with_args ("add_song_from_audio_id", [a_audio_id])
			index_by_audio_id.search (a_audio_id)
			if index_by_audio_id.found then
				extend (index_by_audio_id.found_item)
				lio.put_line (last.artist + ": " + last.title)
			else
				lio.put_string_field ("Not found", a_audio_id.out)
				lio.put_new_line
			end
			log.exit
		end

	add_song_from_path (a_song_file_path: EL_FILE_PATH)
		do
			index_by_location.search (a_song_file_path)
			if index_by_location.found then
				extend (index_by_location.found_item)
			end
		end

	set_name (a_name: like name)
		do
			name := a_name
			if a_name.is_empty then
				create id.make_default
			else
				create id.make_from_array (Digest.md5 (a_name.to_utf_8))
			end
		end

feature {NONE} -- Implementation

	index_by_audio_id: HASH_TABLE [RBOX_SONG, EL_UUID]
		do
			Result := Database.songs_by_audio_id
		end

	index_by_location: HASH_TABLE [RBOX_SONG, EL_FILE_PATH]
		do
			Result := Database.songs_by_location
		end

	silence_intervals: ARRAY [RBOX_SONG]
		do
			Result := Database.silence_intervals
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["location/text()", agent
					do
						add_song_from_path (Database.decoded_location (node.to_string_8))
					end
				],
				["audio-id/text()", agent
					do
						add_song_from_audio_id (create {EL_UUID}.make_from_string (node.to_string_8))
					end
				],
				["@name", agent do set_name (node.to_string) end]
			>>)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent: ZSTRING do Result := name end],
				["entries", agent: ITERABLE [RBOX_SONG] do Result := Current end]
			>>)
		end

feature {NONE} -- Constants

	Date_checker: DATE_VALIDITY_CHECKER
		once
			create Result
		end

	Date_format: STRING = "yyyy-mm-dd"

	M3U_extension: ZSTRING
		once
			Result := "m3u"
		end

	Playlists_dir: EL_DIR_PATH
		once
			Result := "playlists"
		end

end
