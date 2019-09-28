note
	description: "Fourier math test client app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 11:33:03 GMT (Tuesday 19th June 2018)"
	revision: "8"

class
	FOURIER_MATH_TEST_CLIENT_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Ask_user_to_quit, option_name
		end

	INSTALLABLE_SUB_APPLICATION

	EL_REMOTE_CALL_CONSTANTS

	EL_MODULE_EVOLICITY_TEMPLATES

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		local
			time: TIME
		do
			create connection.make (8001, "localhost")

			create signal_math.make (connection)
			create fast_fourier_transform.make (connection)

			Args.set_boolean_from_word_option ("binary", agent set_binary_transmission)

			if is_binary_transmission then
				connection.set_inbound_transmission_type (Transmission_type_binary)
				connection.set_outbound_transmission_type (Transmission_type_binary)
			end

			create random.make
			create time.make_now
			random.set_seed (time.compact_time)
			Args.set_integer_from_word_option ("duration", agent set_running_time_secs, 5)

			Evolicity_templates.set_horrible_indentation
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")

			basic_test (4, 7, 0.5, fast_fourier_transform.Rectangular_windower)
			basic_test (2, 7, 0.1, fast_fourier_transform.Rectangular_windower)
			basic_test (8, 8, 0.7, fast_fourier_transform.Default_windower)

			repeat_random_tests

			connection.close
			log.exit
		end

	basic_test (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE; windower: EL_EIFFEL_IDENTIFIER)
			--
		local
			test_wave_form: COLUMN_VECTOR_COMPLEX_DOUBLE
			preconditions_ok: BOOLEAN
		do
			test_wave_form := signal_math.cosine_waveform (i_freq, log2_length, phase_fraction)

			if not signal_math.has_error then
				print_vector (test_wave_form)

				if fast_fourier_transform.is_power_of_two (test_wave_form.count) then
					fast_fourier_transform.fft_make (test_wave_form.count)
					fast_fourier_transform.set_windower (windower)
					if fast_fourier_transform.is_valid_input_length (test_wave_form.count) then
						fast_fourier_transform.set_input (test_wave_form)

						if fast_fourier_transform.is_output_length_valid then
							preconditions_ok := true
							fast_fourier_transform.do_transform
							if not fast_fourier_transform.has_error and fast_fourier_transform.last_procedure_call_ok then
								print_vector (fast_fourier_transform.output)
							else
								log.put_line ("ERROR: call to do_transform failed")
							end
						end
					end
				end
				if not preconditions_ok then
					log.put_line ("ERROR: FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE requirement failed")
				end
			else
				log.put_line ("ERROR: signal_math.cosine_waveform failed")
			end
		end

	repeat_random_tests
			--
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			timer.start
			from until timer.elapsed_time.seconds_count > running_time_secs loop
				random_test
				timer.update
			end
		end

	random_test
			--
		local
			phase_fraction: DOUBLE
			i_freq, log2_length: INTEGER
			windower: EL_EIFFEL_IDENTIFIER
		do
			log.enter ("random_test")
			random.forth
			phase_fraction := random.double_item

			random.forth
			i_freq := (random.item \\ 2 + 1) * 4
			check
				valid_i_freq: i_freq = 4 or i_freq = 8
			end

			random.forth
			log2_length := random.item \\ 7 + 4
			check
				correct_range: (4 |..| 10).has (log2_length)
			end

			random.forth
			windower := fast_fourier_transform.Windower_types [random.item \\ 2 + 1]

			basic_test (i_freq, log2_length, phase_fraction, windower)
			log.exit
		end

feature -- Element change

	set_running_time_secs (running_time: INTEGER)
			--
		do
			running_time_secs := running_time
		end

	set_binary_transmission (flag: BOOLEAN)
			--
		do
			is_binary_transmission := flag
		end

feature {NONE} -- Implementation

	print_vector (vector: VECTOR_COMPLEX_DOUBLE)
			--
		local
			i: INTEGER
			c: COMPLEX_DOUBLE
		do
			log.enter ("print_vector")
			lio.put_string ("Vector rows [10 of ")
			lio.put_integer (vector.count)
			lio.put_line ("]:")
			from i := 1 until i > 10 loop
				c := vector [i]
				lio.put_integer (i)
				lio.put_string (": "); lio.put_double (c.r)
				lio.put_string (" + "); lio.put_double (c.i); lio.put_line ("i")
				i := i + 1
			end
			lio.put_line ("..")
			log.exit
		end

	running_time_secs: INTEGER

	random: RANDOM

	connection: EL_EROS_CLIENT_CONNECTION

	is_binary_transmission: BOOLEAN

feature {NONE} -- Remote objects

	signal_math: SIGNAL_MATH_PROXY

	fast_fourier_transform: FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY

feature {NONE} -- Installer constants

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("fourier-client.png")
		end

	Desktop: EL_CONSOLE_APP_MENU_DESKTOP_ENV_I
			--
		once
			Result := new_console_app_menu_desktop_environment
			Result.set_command_line_options (<< {EL_LOG_COMMAND_OPTIONS}.Logging, "duration 20" >>)
			Result.set_terminal_position (200, 400)
		end

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = true

	Option_name: STRING = "test_client"

	Description: STRING = "Test client to generate random wave forms and do fourier transforms for 25 seconds"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FOURIER_MATH_TEST_CLIENT_APP}, All_routines],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY}, All_routines],
				[{SIGNAL_MATH_PROXY}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY}, All_routines]
			>>
		end

end
