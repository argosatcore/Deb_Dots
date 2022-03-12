#!/usr/bin/sh
set -e

cd ~/Desktop/vimwiki/
doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" --bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
pdftoread="${doc%%.*}"
	if [ -n "$doc" ]; then
	pandoc "$doc" -M lang:es -s -o $HOME/Desktop/vimwiki/Pdfs/"$pdftoread".pdf -F $HOME/.vim/pluged/zotcite/python3/zotref.py -F pandoc-citeproc --csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl
	fi
