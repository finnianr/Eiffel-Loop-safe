note
	description: "Encryptable xml element list editions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_ENCRYPTABLE_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE -> {EL_ENCRYPTABLE, EL_STORABLE_XML_ELEMENT} create make_default end]

inherit
	EL_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE]
		rename
			make as make_editions
		redefine
			prepare_element, store_edition,  apply_edition
		end

	EL_ENCRYPTABLE
		rename
			encrypter as main_encrypter
		end

create
	make

feature {NONE} -- Initialization

	make (a_target_list: like target_list; a_file_path: EL_FILE_PATH; a_encrypter: like main_encrypter)
			--
		do
			main_encrypter := a_encrypter
			make_editions (a_target_list, a_file_path)
		end

feature {NONE} -- Implementation

	apply_edition (edition: like Type_edition)
			--
		do
			Precursor (edition)
			if edition.has_element then
				edition.element.set_encrypter (main_encrypter)
			end
		end

	store_edition (edition: like Type_edition)
			--
		do
			if edition.has_element then
				edition.element.set_encrypter (create {EL_AES_ENCRYPTER}.make_from_key (main_encrypter.key_data))
			end
			Precursor (edition)
			if edition.has_element then
				edition.element.set_encrypter (main_encrypter)
			end
		end

	prepare_element (element: STORABLE_TYPE)
			--
		do
			element.set_encrypter (create {EL_AES_ENCRYPTER}.make_from_key (main_encrypter.key_data))
		end

end