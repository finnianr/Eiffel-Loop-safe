note
	description: "[
		Comma separated words list storable as a recoverable chain. It's intended use is for making the entries
		of a [$source EL_WORD_TOKEN_TABLE] persistent.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:48:54 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_COMMA_SEPARATED_WORDS_LIST

inherit
	ECD_RECOVERABLE_CHAIN [EL_COMMA_SEPARATED_WORDS]
		rename
			make_chain_implementation as make_list
		undefine
			valid_index, is_inserted, is_equal,
			first, last,
			do_all, do_if, there_exists, has, for_all,
			start, search, finish,
			append_sequence, swap, force, copy, prune_all, prune, move, new_cursor,
			at, put_i_th, i_th, go_i_th
		redefine
			make_from_file
		select
			remove, extend, replace
		end

	EL_ARRAYED_LIST [EL_COMMA_SEPARATED_WORDS]
		rename
			make as make_list,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		export
			{ECD_CHAIN} set_area
		end

	STRING_HANDLER
		undefine
			copy, is_equal
		end

	EL_EVENT_LISTENER
		rename
			notify as on_table_update
		undefine
			copy, is_equal
		end

	EL_MODULE_BUILD_INFO

create
	make, make_encrypted

feature {NONE} -- Initialization

	make (a_table: EL_WORD_TOKEN_TABLE; a_file_path: EL_FILE_PATH)
		do
			set_table (a_table)
			make_from_file (a_file_path)
		end

	make_encrypted (a_table: EL_WORD_TOKEN_TABLE; a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			set_table (a_table)
			make_from_encrypted_file (a_file_path, a_encrypter)
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			is_restored := a_file_path.exists
			Precursor (a_file_path)

			if editions.has_checksum_mismatch then
				is_restored := False
			end
			if is_restored then
				from start until after loop
					item.word_list.do_all (agent table.put)
					forth
				end
				table.set_restored
				last_table_count := table.count
			else
				wipe_out
				safe_store
				editions.close_and_delete
				editions.reopen
			end
		end

feature -- Status query

	is_restored: BOOLEAN

feature -- Measurement

	estimated_byte_count: INTEGER
		local
			sum_header_count: INTEGER
		do
			sum_header_count := count * {PLATFORM}.Integer_32_bytes
			Result := sum_header_count + sum_integer (agent {like item}.byte_count (reader_writer))
		end

	set_table (a_table: like table)
		do
			table := a_table
			table.set_listener (Current)
		end

feature {NONE} -- Implementation

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end

feature {NONE} -- Event handler

	on_delete
		do
		end

	on_table_update
		-- extend any new words from `table' of word tokens.
		local
			new_words: EL_ZSTRING_LIST
			delta_count: INTEGER
		do
			if table.count > last_table_count then
				delta_count := table.count - last_table_count
				last_table_count := table.count
				new_words := table.word_list.sub_list (last_table_count - delta_count + 1, last_table_count)
				extend (new_words)
			end
		end

feature {NONE} -- Internal attributes

	last_table_count: INTEGER

	table: EL_WORD_TOKEN_TABLE
end
