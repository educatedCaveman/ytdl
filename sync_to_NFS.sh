#!/bin/bash
# script for cron to run
# will copy any of the specified file types to somewhere on mobius

# check for another running instance, and exit if found
pnums=$(/usr/bin/pgrep $0)
if [[ -n $pnums ]]; then
    exit 0
fi

# main variables
MUSIC_TYPES=(".mp3")
MUSIC_SRC="/docker/docker-compose/ytdl/audio"
MUSIC_DEST="/mnt/mobius/Music/staging"
# MUSIC_TYPES=(".sh")
# MUSIC_SRC="/home/drake/github/docker-compose/ytdl"
# MUSIC_DEST="/tmp"
TIMEOUT=5

# allow for there being multiple file types.
for file_type in "${MUSIC_TYPES[@]}"
do 
    # for each file of the specified type
    # for file in $(find "${MUSIC_SRC}" -name "*${file_type}" -print)
    for file in *$file_type
    do
        # echo "file name: '$file'"
        # wait for it to be done downloading, then copy it to the destination
        FILE_SIZE=$(/usr/bin/stat -c "%s" "${file}")
        # sleep $TIMEOUT
        NEW_SIZE=$(/usr/bin/stat -c "%s" "${file}")

        while [[ "${NEW_SIZE}" -ne "${FILE_SIZE}" ]]
        do
            # recheck, wait, then check again
            FILE_SIZE=$(/usr/bin/stat -c "%s" "${file}")
            sleep $TIMEOUT
            NEW_SIZE=$(/usr/bin/stat -c "%s" "${file}")
        done

        cp "${file}" "${MUSIC_DEST}"

    done
done