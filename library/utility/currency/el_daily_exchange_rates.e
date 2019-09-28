note
	description: "Daily exchange rates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-16 1:20:17 GMT (Wednesday 16th January 2019)"
	revision: "5"

class
	EL_DAILY_EXCHANGE_RATES [RATES -> EL_EXCHANGE_RATE_TABLE create make end]

feature {NONE} -- Initialization

	make
		do
			create date_today.make_now
			update
		end

feature -- Access

	today, previous: RATES

	currency_code: NATURAL_8
		do
			Result := today.base_currency
		end

feature -- Element change

	check_day
		-- check if `today' is out of date
		do
			date_today.make_now
			if date_today > today.date then
				update
			end
		end

	check_cache
		-- check if there is a newer cached rate table
		local
			cached: like today.cached_dates
		do
			cached := today.cached_dates
			if not cached.is_empty and then cached.first > today.date then
				create today.make (cached.first, Significant_digits)
				set_previous
			end
		end

feature {NONE} -- Implementation

	update
		do
			if attached previous then
				previous := today
			end
			create today.make (date_today.twin, Significant_digits)
			if not attached previous then
				set_previous
			end
		end

	set_previous
		local
			cached: like today.cached_dates
		do
			cached := today.cached_dates
			if cached.valid_index (2) then
				create previous.make (cached [2], Significant_digits)
			else
				previous := today
			end
		end

feature {NONE} -- Internal attributes

	date_today: DATE

feature {NONE} -- Constants

	Significant_digits: INTEGER
		once
			Result := 3
		end

end
