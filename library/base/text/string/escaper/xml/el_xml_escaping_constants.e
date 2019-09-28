note
	description: "Xml escaping constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:20:01 GMT (Wednesday 31st October 2018)"
	revision: "8"

class
	EL_XML_ESCAPING_CONSTANTS

feature {NONE} -- Constants

	Header_template: ZSTRING
		once
			Result := "[
				<?xml version="#" encoding="#"?>
			]"
		end

	Close_tag_marker: ZSTRING
		once
			Result := "</"
		end

	Empty_tag_marker: ZSTRING
		once
			Result := "/>"
		end

	Sign_less_than: ZSTRING
		once
			Result := "<"
		end

	Sign_greater_than: ZSTRING
		once
			Result := ">"
		end

feature {NONE} -- Escaping

	Attribute_escaper: EL_XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Attribute_128_plus_escaper: EL_XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

	Xml_escaper: EL_XML_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Xml_128_plus_escaper: EL_XML_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

end
