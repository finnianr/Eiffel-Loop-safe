note
	description: "File motif emulator c gcc to msvc converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	FILE_MOTIF_EMULATOR_C_GCC_TO_MSVC_CONVERTER

inherit
	GCC_TO_MSVC_CONVERTER
		redefine
			delimiting_pattern
		end

	EL_C_PATTERN_FACTORY

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: like one_of
			--
		do
			Result := Precursor
			Result.extend (praat_winmain_function)
		end

	praat_winmain_function: like all_of
			-- Eg. to match:

			--	int APIENTRY WinMain (HINSTANCE instance, HINSTANCE previousInstance, LPSTR commandLine, int commandShow) {
			--		int argc = 4;
			--		char instanceString [20], commandShowString [20], *argv [4];
			--		(void) previousInstance;
			--		argv [0] = "dummy";
			--		sprintf (instanceString, "%ld", (long) instance);
			--		sprintf (commandShowString, "%d", commandShow);
			--		argv [1] = & instanceString [0];
			--		argv [2] = & commandShowString [0];
			--		argv [3] = commandLine;
			--		return main (argc, & argv [0]);
			--	}
		do
			Result := all_of (<<
				non_breaking_white_space,
				string_literal ("int APIENTRY WinMain"),
				non_breaking_white_space,
				character_literal ('('),
				repeat_p1_until_p2 (
					-- pattern 1
					one_of (<<
						c_identifier,
						character_literal (','),
						non_breaking_white_space
					>>),

					-- pattern 2
					character_literal (')')
				),
				maybe_white_space,
				statement_block

			>>) |to| agent on_praat_winmain_function_statement_block
		end

feature {NONE} -- Match actions

	on_praat_winmain_function_statement_block (text: EL_STRING_VIEW)
			--
		do
			put_new_line
			put_string ("%T#if ! defined (EIFFEL_APPLICATION)")
			put_new_line
			put_string (text)
			put_new_line
			put_string ("%T#endif")

		end

end