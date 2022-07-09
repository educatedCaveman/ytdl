#!/bin/bash

BASE_PATH="/docker/docker-compose/ytdl"
OUT_PATHS=("audio")
DELAY=30

for PATH in "${OUT_PATHS[@]}"
do
    FULL_PATH="${BASE_PATH}/${PATH}"
    find "${FULL_PATH}" -mtime +$DELAY -delete
done
