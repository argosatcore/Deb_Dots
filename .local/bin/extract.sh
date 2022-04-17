#!/usr/bin/sh
set -ex

extractAllTypeFiles(){ 
       if [ -f "$1" ] ; then 
        case $1 in 
           *.ark)       arc x "$1"            ;; 
           *.arc)       arc x "$1"            ;; 
           *.arj)       arj e "$1"            ;; 
           *.cbt)       tar xvf "$1"          ;;
           *.cso)       ciso 0 ./"$1" ./"$1.iso" && \
                extract "$1".iso && \rm -f "$1" ;;
           *.tar.bz2)   tar xvjf "$1"         ;; 
           *.tar.gz)    tar xvzf "$1"         ;; 
           *.tar.lzma)  tar --lzma -xvf "$1"  ;; 
           *.tar.xz)    tar -xf "$1"          ;; 
           *.tar.lz)    lzip -d "$1"          ;; #tar --lzip -tf $1   ;;
           *.tar.7z)    7z x -so "$1" | tar -xf - ;; # tar -cJf
           *.tar.Z)     zcat "$1" | tar -xvf - ;; 
           *.jar)       jar xf "$1"           ;; 
           *.bz2)       bunzip2 "$1"          ;; 
           *.rar)       unrar x "$1"          ;;
           *.cbr)       unrar x -ad "$1"      ;;
           *.gz)        gunzip "$1"           ;; 
           *.cab)       cabextract "$1"       ;;
           *.cpio)      cpio -id < "$1"       ;;
           *.cba|*.ace) unace x "$1"          ;;
           *.tar)       tar xvf "$1"          ;; 
           *.tbz2)      tar xvjf "$1"         ;; 
           *.tgz)       tar xvzf "$1"         ;; 
           *.lz4)       lz4 -d "$1"           ;; 
#           *.lzh)       lha x "$1"            ;; 
           *.xz)        unxz "$1"             ;;
           *.exe)       cabextract "$1"       ;;
           *.zip|*.epub|*.cbz)       unzip "$1"            ;; 
           *.7z|*.z|*.apk|*.deb|*.dmg|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)        7z x "$1"             ;; 
           *.zst)       zstd -dc "$1"         ;; 
           *.zpaq)      zpaq x "$1"           ;;
           *.zoo)       zoo -extract "$1"     ;; 
           *)           echo "File not supported : '$1'..." ;; 
        esac 
       else 
        echo "'$1' is not a valid file!" 
   fi 
 } 
#alias extract=extractAllTypeFiles


if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage: extract <file1> <file2>"
    exit 1
fi

while [ $# -gt 0 ]
do
    extractAllTypeFiles "$1"
    shift 1
done
