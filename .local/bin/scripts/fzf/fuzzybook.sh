#!/bin/sh

# menu (dmenu, rofi, fzf, etc.)
menu_cmd='fzf --multi --cycle --reverse'

# browser
browser_cmd='firefox --new-tab'

# in case the automatic profile detection does not work properly,
# replace <PROFILE> with your profile id (e.g. ik52yqxf.default-1574488801337) and uncomment
#bookmarks_folder=~/.mozilla/firefox/<PROFILE>/weave

# search for profile folder if not specified
if [ -z "$bookmarks_folder" ]; then
	bookmarks_folder=$(find ~/.mozilla/firefox/ -maxdepth 2 -type d | grep -E 'default.*weave' | grep -v -E 'nightly$' | awk 'NR==1')
	if [ -z "$bookmarks_folder" ]; then
		echo "unable to detect firefox profile. please specify manually in source."
		exit 1
	fi
fi

# bookmarks db is always locked when firefox is running
# as a workaround, we can just create a copy of the db
csum_orig=$(sha1sum "${bookmarks_folder}"/bookmarks.sqlite | awk '{print $1}')
csum_copy=$(sha1sum "${bookmarks_folder}"/bookmarks_copy.sqlite 2> /dev/null | awk '{print $1}')

# only create a new copy if the db has been modified
if [ "$csum_orig" != "$csum_copy" ]; then
	/usr/bin/cp -f "${bookmarks_folder}"/bookmarks.sqlite "${bookmarks_folder}"/bookmarks_copy.sqlite
fi

# fetch all bookmark records from copy, show menu and open selected bookmark in browser
sqlite3 "${bookmarks_folder}"/bookmarks_copy.sqlite 'SELECT i.title, u.url FROM items i, urls u WHERE (i.urlId = u.id)' \
| sed 's/|http/\thttp/' \
| $menu_cmd \
| grep -Eo '(http|https)://.*' \
| xargs -r -I {} $browser_cmd {}
