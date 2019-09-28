note
	description: "Currency"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:44:09 GMT (Monday 5th August 2019)"
	revision: "11"

class
	EL_CURRENCY

inherit
	EVOLICITY_SERIALIZEABLE
		undefine
			is_equal
		end

	COMPARABLE

	EL_INTEGER_MATH
		export
			{NONE} all
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_DEFERRED_LOCALE

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {EL_CURRENCY_LOCALE} -- Initialization

	make (a_language: like language; a_code: like code; a_has_decimal: like has_decimal)
		do
			language := a_language; code := a_code; has_decimal := a_has_decimal
			separator := [',', '.']
			set_format_and_symbol (Locale.in (a_language) * Format_key #$ [code_name])
			make_default
		end

feature -- Access

	code: NATURAL_8

	code_name: STRING
		-- EUR, USD etc
		do
			Result := Currency.name (code)
		end

	formatted (amount_x100: INTEGER): ZSTRING
		local
			i, digit_count, separator_count: INTEGER
		do
			digit_count := digits (amount_x100)
			separator_count := (digit_count - 2) // 3
			if has_decimal then
				separator_count := separator_count + 1
			else
				digit_count := digit_count - 2
			end
			create Result.make (digit_count + separator_count + symbol.count + 1)
			Result := amount_x100.out
			if has_decimal then
				i := Result.count - 1
				Result.insert_character (separator.decimal, i)
			else
				Result.remove_tail (2)
				i := Result.count + 1
			end
			from until i <= 1 loop
				i := i - 3
				if i > 1 then
					Result.insert_character (separator.threes, i)
				end
			end
			if is_symbol_first then
				Result.prepend_character (' ')
				Result.prepend (symbol)
			else
				Result.append_character (' ')
				Result.append (symbol)
			end
		end

	language: STRING

	name: ZSTRING
		do
			Result := Locale.in (language) * (Name_key_template #$ [code_name])
		end

	separator: TUPLE [threes, decimal: CHARACTER]

	symbol: ZSTRING

feature -- Element change

	set_format_and_symbol (format: ZSTRING)
		require
			valid_decimal_format: has_decimal implies format.occurrences ('#') = 6
			valid_nondecimal_format: not has_decimal implies format.occurrences ('#') = 4
		local
			pos_hash: INTEGER
		do
			pos_hash := format.index_of ('#', 1)
			is_symbol_first := pos_hash /= 1
			if is_symbol_first then
				symbol := format.substring (1, pos_hash - 2)
			else
				symbol := format.substring_end (format.last_index_of ('#', format.count) + 2)
			end
			separator.threes := format.item (pos_hash + 1).to_character_8
			if has_decimal then
				separator.decimal := format.item (pos_hash + 5).to_character_8
			end
		end

	set_language (a_language: like language)
		do
			language := a_language
		end

feature -- Status query

	has_decimal: BOOLEAN

	is_symbol_first: BOOLEAN

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := name < other.name
		end

feature {NONE} -- Evolicity

	Template: STRING = ""

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["code", agent: STRING do Result := code_name end],
				["name", agent: ZSTRING do Result := name end],
				["symbol", agent: ZSTRING do Result := symbol end]
			>>)
		end

feature {NONE} -- Constants

	Name_key_template: ZSTRING
		once
			Result := "{%S}"
		end

	Format_key: ZSTRING
		once
			Result := "{%S-format}"
		end

end
