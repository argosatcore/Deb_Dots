#!/usr/bin/env bash
set -euo pipefail

if (( $# == 2 )); then
    LOG_DATE=$(date +%Y-%m-%d_%H_%M_%S)

    rsync --progress --stats --archive --xattrs --acls --dry-run \
        --delete-during --human-readable --partial "$1" "$2"

    echo
    echo "Warning! In '$2' some files will be deleted."
    read -p "Are you sure ? [Y/n]" -n 1 -r
    echo

    if [[ $REPLY =~ ^[Y]$ ]]; then
        echo "Sync in 5 seconds..."
        sleep 5
        rsync --progress --stats --archive --acls --partial \
            --delete-during --human-readable --xattrs \
            --log-file=log_rsync_"$LOG_DATE".log "$1" "$2"
    else
        echo "No sync"
    fi
else
    echo "Usage: ${0##*/} <source> <destination>"
    exit 1
fi
