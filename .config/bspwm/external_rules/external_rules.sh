#!/bin/sh

wid=$1
class=$2
instance=$3
csq_buf=$4

event=$(jq -c -n \
    --arg wid "$wid" \
    --arg class "$class" \
    --arg instance "$instance" \
    --arg csq_buf "$csq_buf" \
    '{"wid": $wid, "class": $class, "instance": $instance, "csq_buf": $csq_buf}')

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "[$DATE] $event" >> ~/.bspwm.log.txt

fwid=$(bspc query -N -n focused.automatic)

if [ -n "$fwid" ] ; then
	wattr wh $fwid | {
		read width height
		if [ $width -gt $height ] ; then
			echo "split_dir=east"
		else
			echo "split_dir=south"
		fi
		echo "split_ratio=0.50"
	}
fi

