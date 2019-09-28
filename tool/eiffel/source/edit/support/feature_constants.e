note
	description: "Feature constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	FEATURE_CONSTANTS

feature {NONE} -- Constants

	Feature_catagories: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (20)

			Result ["ac"] := "Access"
			Result ["at"] := "Attributes"
			Result ["aa"] := "Access attributes"
			Result ["bo"] := "Basic operations"
			Result ["co"] := "Constants"
			Result ["cp"] := "Comparison"
			Result ["cs"] := "Contract Support"
			Result ["cv"] := "Conversion"
			Result ["cm"] := "Cursor movement"
			Result ["dm"] := "Dimensions"
			Result ["dp"] := "Disposal"
			Result ["du"] := "Duplication"
			Result ["ec"] := "Element change"
			Result ["er"] := "Evolicity reflection"
			Result ["ev"] := "Event handling"
			Result ["fa"] := "Factory"
			Result ["im"] := "Implementation"
			Result ["ip"] := "Inapplicable"
			Result ["ia"] := "Internal attributes"
			Result ["in"] := "Initialization"
			Result ["me"] := "Measurement"
			Result ["mi"] := "Miscellaneous"
			Result ["ob"] := "Obsolete"
			Result ["rm"] := "Removal"
			Result ["rs"] := "Resizing"
			Result ["sc"] := "Status change"
			Result ["sq"] := "Status query"
			Result ["sr"] := "Status report"
			Result ["td"] := "Type definitions"
			Result ["tf"] := "Transformation"
			Result ["un"] := "Unimplemented"
		end

end