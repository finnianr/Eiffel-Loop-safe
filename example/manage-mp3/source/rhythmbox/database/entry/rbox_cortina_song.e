note
	description: "Rbox cortina song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-04 12:22:06 GMT (Wednesday 4th September 2019)"
	revision: "7"

class
	RBOX_CORTINA_SONG

inherit
	RBOX_SONG
		rename
			make as make_song
		end

	RHYTHMBOX_CONSTANTS
		rename
			Media_type as Media_types
		end

	EL_MODULE_AUDIO_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_source_song: RBOX_SONG; tanda_type: ZSTRING; a_track_number, a_duration: INTEGER)
		do
			make_song
			source_song := a_source_song; track_number := a_track_number; duration := a_duration
			if tanda_type ~ Tanda.the_end then
				title := Tanda.the_end
			else
				title := Title_template #$ ['A' + (track_number - 1), tanda_type.as_upper]
				title.append (create {ZSTRING}.make_filled ('_', 30 - title.count))
			end
			artist := source_song.artist
			genre := Extra_genre.cortina
			mp3_path := music_dir.joined_file_steps (<< genre, artist, title + ".mp3" >>)
			album := source_song.album
		end

feature -- Access

	source_song: RBOX_SONG

feature -- Basic operations

	write_clip (a_offset_secs: INTEGER; a_fade_in_duration, a_fade_out_duration: REAL)
			-- Write clip from full length song at offset with fade in and fade out
		local
			clip_saver: like Audio_command.new_mp3_to_wav_clip_saver
			convertor: like Audio_command.new_wav_to_mp3; fader: like Audio_command.new_wav_fader
			wav_path, faded_wav_path: EL_FILE_PATH
			audio_properties: like Audio_command.new_audio_properties
		do
			wav_path := mp3_path.with_new_extension ("wav")
			faded_wav_path := mp3_path.with_new_extension ("faded.wav")

			-- Cutting
			clip_saver := Audio_command.new_mp3_to_wav_clip_saver (source_song.mp3_path, wav_path)
			clip_saver.set_duration (duration); clip_saver.set_offset (a_offset_secs)

			File_system.make_directory (mp3_path.parent)
			clip_saver.execute

			-- Fading
			fader := Audio_command.new_wav_fader (wav_path, faded_wav_path)
			fader.set_duration (duration)
			fader.set_fade_in (a_fade_in_duration)
			fader.set_fade_out (a_fade_out_duration)
			fader.execute
			OS.delete_file (wav_path)

			-- Compressing
			convertor := Audio_command.new_wav_to_mp3 (faded_wav_path, mp3_path)
			audio_properties := Audio_command.new_audio_properties (mp3_path)
			convertor.set_bit_rate_per_channel (audio_properties.bit_rate)
			convertor.execute
			OS.delete_file (faded_wav_path)

			write_id3_info (id3_info)
		end

feature {NONE} -- Constants

	Title_template: ZSTRING
		once
			Result := "%S. %S tanda "
		end

end
