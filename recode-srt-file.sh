#!/usr/bin/env bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

FILE_PARAMETER="-i"

# -I on macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
    FILE_PARAMETER="-I"
fi

ENCODING_TO="UTF-8"

if [[ $# -ne 1 ]]; then
    (>&2 echo "Usage: $0 srt_file")
    exit 1
fi

SRT_FILE="$1"

if [[ ! -f "$SRT_FILE" ]]; then
    (>&2 echo "The file $SRT_FILE does not exist.")
    exit 2
fi

ENCODING_FROM=`file ${FILE_PARAMETER} "$1" | sed "s/.*charset=\(.*\)$/\1/" | tr [a-z] [A-Z]`

if [[ "$ENCODING_FROM" == "UNKNOWN-8BIT" ]]; then
    ENCODING_FROM="WINDOWS-1252"
fi

if [[ "$ENCODING_FROM" == "$ENCODING_TO" ]]; then
    echo "$0: the file $SRT_FILE is already in UTF-8 format."
else
    echo "recode: converting file $SRT_FILE from $ENCODING_FROM to $ENCODING_TO..."
    recode "$ENCODING_FROM".."$ENCODING_TO" "$SRT_FILE"
fi

dos2unix "$SRT_FILE"

exit 0
