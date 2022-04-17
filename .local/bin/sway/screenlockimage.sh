#!/bin/sh
grim /tmp/lockscreen.png && convert -filter Gaussian -resize 20% -blur 0x2.5 -resize 500% /tmp/lockscreen.png /tmp/lockscreen.png
