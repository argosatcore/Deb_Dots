#!/bin/bash

[[ $1 ]] && url="$1" || url="$(xclip -o)"

#"aac", "flac", "mp3", "m4a", "opus", or "wav"

echo "$url"
yt-dlp --extract-audio --audio-format opus "$url"
