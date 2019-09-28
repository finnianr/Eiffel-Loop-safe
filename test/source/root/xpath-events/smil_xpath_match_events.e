note
	description: "Smil xpath match events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-14 8:34:53 GMT (Friday 14th June 2019)"
	revision: "6"

class
	SMIL_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	EL_XML_PARSE_EVENT_TYPE

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- XPath match event handlers

	on_audio_title
			--
		do
			log.put_string_field ("AUDIO TITLE", last_node.to_string)
			log.put_new_line
		end

	on_meta_tag
			--
		do
			log.put_string_field ("META NAME", last_node.to_string)
			log.put_new_line
		end

	increment_audio_count
			--
		do
			count := count + 1
		end

	on_smil_end
			--
		do
			log.put_integer_field ("AUDIO COUNT", count)
			log.put_new_line
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := <<
				-- Fixed paths
				[on_open, "/smil/body/seq/audio/@title", agent on_audio_title],

				[on_close, "/smil", agent on_smil_end],

				-- Wild card paths
				[on_open, "//audio", agent increment_audio_count],
				[on_open, "//meta/@name", agent on_meta_tag]
			>>
		end

	count: INTEGER

end
