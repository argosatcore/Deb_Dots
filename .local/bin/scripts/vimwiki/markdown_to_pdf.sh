#!/usr/bin/bash
set -e

cd $HOME/Desktop/vimwiki/
doc="$(fdfind -t f -H | fzf --reverse --color=border:#FFFFFF --preview="less {}" \
	--bind="space:toggle-preview" --preview-window=:80%:wrap:hidden)"
pdftoread="$(echo ${doc%%.*})"
cleanpdfname="${pdftoread##*/}"
	if [ -n "$doc" ]; then
	pandoc "$doc" --pdf-engine=xelatex -V 'fontsize:12pt' -V 'indent:yes' \
	--variable monofont="Menlo" -V "geometry:margin=2.54cm" -V 'papersize:letter' \
	-M lang:es -s -o $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf \
	-F $HOME/.vim/pluged/zotcite/python3/zotref.py -F pandoc-citeproc \
	--csl=$HOME/Zotero/styles/chicago-fullnote-bibliography.csl ; xdg-open  $HOME/Desktop/vimwiki/Pdfs/"$cleanpdfname".pdf & disown; exit
	fi
