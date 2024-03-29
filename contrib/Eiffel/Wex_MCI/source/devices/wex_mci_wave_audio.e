indexing
	description: "This class represents the waveaudio MCI device."
	status: "See notice at end of class."
	author: "Robin van Ommeren"
	date: "$Date: 1998/07/22 19:55:29 $"
	revision: "$Revision: 1.1 $"

class
	WEX_MCI_WAVE_AUDIO

inherit
	WEX_MCI_DEVICE

	WEL_WORD_OPERATIONS
		export
			{NONE} all
		end

	WEX_MCI_WAVE_SET_CONSTANTS
		export
			{NONE} all
		end

	WEX_MCI_WAVE_STATUS_CONSTANTS
		export
			{NONE} all
		end

	WEX_MCI_WAVE_GETDEVCAPS_CONSTANTS
		export
			{NONE} all
		end

	WEX_MCI_WAVE_FORMAT_CONSTANTS
		export
			{NONE} all
		end

	WEX_MCI_SAVE_CONSTANTS
		export
			{NONE} all
		end

creation
	make

feature -- Basic operations

	open (file: STRING) is
			-- Open a Mci device to play an audio file `file'.
		require
			not_opened: not opened
			file_not_void: file /= Void
--			WEXCHANGE
			file_meaningful: not file.is_empty
		local
			open_parms: WEX_MCI_WAVE_OPEN_PARMS
		do
			create open_parms.make (parent, device_name)
			open_parms.set_element_name (file)
			open_device (open_parms, Mci_open_element + Mci_open_type)
		end

	open_new is
			-- Open the wave audio device with a blank file for
			-- recording.
		require
			not_opened: not opened
		local
			open_parms: WEX_MCI_WAVE_OPEN_PARMS
		do
			create open_parms.make (parent, device_name)
			open_parms.set_element_name ("")
			open_device (open_parms, Mci_open_element +
				Mci_open_type)
		end

	save (file_name: STRING) is
			-- Save the current buffer to file `file_name'.
		require
			opened: opened
			file_name_not_void: file_name /= Void
--			WEXCHANGE
			file_name_meaningful: not file_name.is_empty
		local
			save_parms: WEX_MCI_SAVE_PARMS
		do
			create save_parms.make (parent)
			save_parms.set_file (file_name)
			save_device (save_parms, Mci_save_file)
		end

	record is
			-- Record from current position until stopped.
		require
			opened: opened
		local
			record_parms: WEX_MCI_RECORD_PARMS
		do
			create record_parms.make (parent, 0, 0)
			record_device (record_parms, 0)
		end

	cue_recording is
			-- Cue the device for recording.
			--| After cueing the device starts with minimum delay.
		require
			opened: opened
		local
			generic_parms: WEX_MCI_GENERIC_PARMS
		do
			create generic_parms.make (parent)
			cue_device (generic_parms, Mci_wave_input)
		end			

	cue_play_back is
			-- Cue the device for play back.
			--| After cueing the device starts with minimum delay.
		require
			opened: opened
		local
			generic_parms: WEX_MCI_GENERIC_PARMS
		do
			create generic_parms.make (parent)
			cue_device (generic_parms, Mci_wave_output)
		end

	seek_to (a_position: INTEGER) is
			-- Position the audio file at `a_position'.
		require
			opened: opened
			a_positive_position: a_position >= 0
			a_valid_position: a_position <= media_length
		local
			seek_parms: WEX_MCI_SEEK_PARMS
		do
			create seek_parms.make (parent, a_position)
			seek_device (seek_parms, Mci_to)
		end

feature -- Status report

	number_of_wave_input_devices: INTEGER is
			-- The total number of waveform input
			-- (recording) devices.
		require
			opened: opened
		do
			Result := query_device_capability_item (
				Mci_getdevcaps_item,
				Mci_wave_getdevcaps_inputs)
		end

	number_of_wave_output_devices: INTEGER is
			-- The total number of waveform output
			-- (playback) devices.
		require
			opened: opened
		do
			Result := query_device_capability_item (
				Mci_getdevcaps_item,
				Mci_wave_getdevcaps_outputs)
		end

	samples_per_second: INTEGER is
			-- Current samples per second used for playing,
			-- recording, and saving.
		require
			opened: opened
		do
			Result := query_status_item (
				Mci_wave_status_samplespersec)
		end

	bytes_per_second: INTEGER is
			-- Current average bytes per second for playing
			-- and recording.
		require
			opened: opened
		do
			Result := query_status_item (
				Mci_wave_status_avgbytespersec)
		end

	bits_per_sample: INTEGER is
			-- Current bits per sample used for playing
			-- and recording.
		require
			opened: opened
		do
			Result := query_status_item (
				Mci_wave_status_bitspersample)
		end

	current_block_alignment: INTEGER is
			-- Current block alignment used for playing
			-- and recording.
		require
			opened: opened
		do
			Result := query_status_item (Mci_wave_status_blockalign)
		end

	channels: INTEGER is
			-- Current channel count used for playing,
			-- recording, and saving.
                        --| 1 for mono, 2 for stereo
		require
			opened: opened
		do
			Result := query_status_item (Mci_wave_status_channels)
		end

	right_channel_level: INTEGER is
			-- The right or mono channel level
		require
			opened: opened
		do
--			WEXCHANGE
--			Result := cwin_lo_word (query_status_item (Mci_wave_status_level))
			Result := win_lo_word (query_status_item (Mci_wave_status_level))
		end

	left_channel_level: INTEGER is
			-- The left channel level
		require
			opened: opened
		do
--			WEXCHANGE
--			Result := cwin_hi_word (query_status_item (Mci_wave_status_level))
			Result := win_hi_word (query_status_item (Mci_wave_status_level))
		end

feature -- Status setting

        set_input_channel (channel: INTEGER) is
                        -- Set the input channel to `channel'.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_input_channel (channel)
                        set_device (wave_set_parms, Mci_wave_input)
                end

        set_output_device (device: INTEGER) is
                        -- Set the device to use for output.
                        --| requires at least 2 devices capable of wave audio
			--| in system.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_output_device (device)
                        set_device (wave_set_parms, Mci_wave_output)
                end

        set_any_input is
                        -- Any wave input compatible with the current format
                        -- will be used for recording.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMs
                do
                        create wave_set_parms.make (parent)
                        set_device (wave_set_parms, Mci_wave_set_anyinput)
                end

        set_any_output is
                        -- Any wave output compatible with the current format
                        -- will be used for playing.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        set_device (wave_set_parms, Mci_wave_set_anyoutput)
                end

        set_bytes_per_second (number_of_bytes: INTEGER) is
            -- Sets the bytes per second used for playing,
			-- recording, and saving.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_bytes_per_second (number_of_bytes)
                        set_device (wave_set_parms, Mci_wave_set_avgbytespersec)
                end

        set_bits_per_sample (number_of_bits: INTEGER) is
                        -- Sets the bits per sample used for playing,
			-- recording, and saving.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_bits_per_sample (number_of_bits)
                        set_device (wave_set_parms, Mci_wave_set_bitspersample)
                end

        set_block_alignment (block_alignment: INTEGER) is
             -- Sets the block alignment used for playing,
			-- recording, and saving.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_block_alignment (block_alignment)
                        set_device (wave_set_parms, Mci_wave_set_blockalign)
                end

        set_stereo is
                        -- Set the number of channels used to 2 (stereo).
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_channels (2)
                        set_device (wave_set_parms, Mci_wave_set_channels)
                end

        set_mono is
            -- Set the number of channels used to 1 (mono).
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_channels (1)
                        set_device (wave_set_parms, Mci_wave_set_channels)
                end

        set_wave_format (format: INTEGER) is
                        -- Sets the format type used for playing,
			-- recording, and saving.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
                        wave_set_parms: WEX_MCI_WAVE_SET_PARMS
                do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_format_tag (format)
                        set_device (wave_set_parms, Mci_wave_set_formattag)
                end

        set_wave_format_pcm is
                        -- Sets the format type to PCM.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
                require
                        opened: opened
                local
					wave_set_parms: WEX_MCI_WAVE_SET_PARMS
				do
                        create wave_set_parms.make (parent)
                        wave_set_parms.set_format_tag (Wave_format_pcm)
                        set_device (wave_set_parms, Mci_wave_set_formattag)
                end

        set_samples_per_second (number_of_samples: INTEGER) is
                        -- Sets the samples per second used for playing,
			-- recording, and saving.
			--| This property of waveform-audio data is defined
			--| when the file to store the data is created.
			--| This cannot be changed once recording begins.
            require
                 opened: opened
            local
				wave_set_parms: WEX_MCI_WAVE_SET_PARMS
			do
                create wave_set_parms.make (parent)
                wave_set_parms.set_samples_per_second (number_of_samples)
                set_device (wave_set_parms, Mci_wave_set_samplespersec)
            end

feature {NONE} -- Implementation

	save_device (parms: WEX_MCI_SAVE_PARMS; save_flags: INTEGER) is
			-- Save the buffer to a file.
		require
			opened: opened
			parms_not_void: parms /= Void
			parms_exists: parms.exists
		do
			send_command (Mci_save, save_flags, parms)
		end

	device_name: STRING is
			-- Device name
		once
			Result := "waveaudio"
		end
		
	win_lo_word (value: INTEGER): INTEGER is
			--
		do
			Result := value & 0xFFFF
		end

	win_hi_word (value: INTEGER): INTEGER is
			--
		do
			Result := value |>> 16
		end


end -- class WEX_MCI_WAVE_AUDIO

--|-------------------------------------------------------------------------
--| WEX, Windows Eiffel library eXtension
--| Copyright (C) 1998  Robin van Ommeren, Andreas Leitner
--| See the file forum.txt included in this package for licensing info.
--|
--| Comments, Questions, Additions to this library? please contact:
--|
--| Robin van Ommeren						Andreas Leitner
--| Eikenlaan 54M								Arndtgasse 1/3/5
--| 7151 WT Eibergen							8010 Graz
--| The Netherlands							Austria
--| email: robin.van.ommeren@wxs.nl		email: andreas.leitner@teleweb.at
--| web: http://home.wxs.nl/~rommeren	web: about:blank
--|-------------------------------------------------------------------------
