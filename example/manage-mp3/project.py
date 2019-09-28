# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

version = (1, 4, 4); build = 377

installation_sub_directory = 'Eiffel-Loop/manage-mp3'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_rhythmbox_read_write', '-logging'])

# 1.4.4
# Fixed missing songs in playlists by reading playlists after reading songs

# 1.4.3
# Fixed all test task so they pass, and task now implemented using RBOX_MANAGEMENT_TASK

# 1.4.2
# Fixed bug EL_WAV_FADER_I for substitution variables

# 1.4.1
# Added new Gvfs_file_not_found_errors: "The specified location is not mounted"
# Fixed TEST_STORAGE_DEVICE.set_volume and checksum for rhythmdb-tasks/export_music_to_device.pyx

# 1.4.0
# 25 Sep 2016
# Introduced music_dir in task configuration with default value of $HOME/Music
# Change structure of DJ playlists to use "mp3-path" for location list

# 1.3.9
# Integrated DJ event playlists more tightly by placing them $HOME/Music/Playlists and adding them to the database
# as ignored entries with genre "playlist" and media type "text/pyxis"

# 1.3.8
# Removed bridge pattern

# 1.3.7
# Set increased bitrate to compensate for quality loss of AAC -> MP3 conversion
# Changed conversion command to use single unpiped avconv command

# 1.3.6
# Added video segment cutting accurate to 0.001 seconds

# 1.3.5
# Fixed recover_from_error routine which did not restore log stack to working state
# Stopped gfvs-rm from triggering exception if file not found

# 1.3.4
# Applied data safety measures to copying sync tabl

# 1.3.3
# Create {MEDIA_ITEM}.exported_relative_path

# 1.3.2
# Protection against case-insensitive name clashes that would disrupt MTP export

# 1.3.1
# Playlists now included in sync table

# 1.3.0
# Exception based MTP error recovery

# 1.2.9
# Added export named playlist

# 1.2.8
# Changed escaping of command path arguments

# 1.2.7
# Changed audio id format to md4 including audio data size
# 

# 1.2.6
# Read exported playlists directory before publishing
# Save ignore attribute in exported playlist

# 1.2.5
# Fixed escaping of Unix paths in shell commands

# 1.2.4
# Fixed saving of DJ event lists with X before unplayed songs

# 1.2.3
# Detects Rhythmbox. Fixed volume sync deletions. Put tanda number in playlist song info.
# Changed Tanda naming to A. <GENRE> Tanda ****
