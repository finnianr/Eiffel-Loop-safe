note
	description: "Dj events publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-16 14:41:20 GMT (Monday   16th   September   2019)"
	revision: "7"

class
	DJ_EVENTS_PUBLISHER

inherit
	ANY

	EL_MODULE_USER_INPUT

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initiliazation

	make (a_config: like config; a_playlists: like playlists)
			--
		do
			config := a_config
			create playlists.make (a_playlists.count)
			across a_playlists as playlist loop
				if playlist.item.is_publishable then
					playlists.extend (playlist.item)
				end
			end
			create file_upload_list.make
		end

feature -- Basic operations

	publish
		local
			index_html_path, playlist_path: EL_FILE_PATH; website: EL_FTP_WEBSITE
			html_index: DJ_EVENTS_HTML_INDEX
			event_page: DJ_EVENT_HTML_PAGE
		do
			index_html_path := config.www_dir + "index.html"
			create html_index.make (playlists.to_array, config.www_dir + config.html_index_template, index_html_path)
			html_index.serialize
			file_upload_list.extend (new_copy_file_arguments (index_html_path, config.ftp_destination_dir))

			across playlists as list loop
				playlist_path := config.www_dir + list.item.html_page_name
				if not playlist_path.exists then
					lio.put_labeled_string ("Writing", list.item.html_page_name)
					lio.put_new_line
					create event_page.make (list.item, config.www_dir + config.html_template, playlist_path)
					event_page.serialize
					file_upload_list.extend (new_copy_file_arguments (playlist_path, config.ftp_destination_dir))
				end
			end
			if config.upload then
				lio.put_string ("Upload pages (y/n) ")
				if user_input.entered_letter ('y') then
					create website.make (config.ftp_url, config.ftp_user_home)
					website.login
					if website.is_initialized and then website.is_logged_in then
						website.do_ftp_upload (file_upload_list)
					end
				end
			end
		end

feature {NONE} -- Factory

	new_copy_file_arguments (source_path: EL_FILE_PATH; destination_dir: EL_DIR_PATH): EL_FTP_UPLOAD_ITEM
		do
			create Result.make (source_path, destination_dir)
		end

feature {NONE} -- Implementation: attributes

	file_upload_list: LINKED_LIST [EL_FTP_UPLOAD_ITEM]

	config: DJ_EVENT_PUBLISHER_CONFIG

	playlists: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]

end
