#!/usr/bin/env bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

TVSHOW_EXTENSION="mkv"
SUBTITLE_EXTENSION="srt"
FINAL_DIRECTORY="/my_final/folder"
FILEBOT_FORMAT="{plex}"
LANG="en"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 tv_show_1 [tv_show_2 tv_show_3 ...]"
    exit 1
fi

for PARAM_DIRECTORY in "$@"
do
    if [[ ! -d "$PARAM_DIRECTORY" ]]; then
        echo "The folder '$PARAM_DIRECTORY' does not exist."
        continue
    fi

    if [[ ! "$(ls "$PARAM_DIRECTORY" | grep "$TVSHOW_EXTENSION")" ]]; then
        echo "The folder '$PARAM_DIRECTORY' contains no '$TVSHOW_EXTENSION' files."
        continue
    fi

    if [[ ! "$(ls "$PARAM_DIRECTORY" | grep "$SUBTITLE_EXTENSION")" ]]; then
        echo "The folder '$PARAM_DIRECTORY' contains no '$SUBTITLE_EXTENSION' files."
        continue
    fi

    filebot -rename "$PARAM_DIRECTORY/"*."$TVSHOW_EXTENSION" --format "$FILEBOT_FORMAT" --db TheTVDB --lang $LANG -non-strict
    filebot -rename "$PARAM_DIRECTORY/"*."$SUBTITLE_EXTENSION" --format "$FILEBOT_FORMAT{subt}" --db TheTVDB --lang $LANG -non-strict

    find "$PARAM_DIRECTORY" -maxdepth 1 -name "*.$TVSHOW_EXTENSION" | while read FILE
    do
        TITLE=`basename "$FILE" ."$TVSHOW_EXTENSION"`
        TRACK_NAME=`echo "$TITLE" | cut -d "-" -f 3 | awk '{$1=$1};1'`
        SUBTITLE_ENG="$PARAM_DIRECTORY/$TITLE.eng.$SUBTITLE_EXTENSION"
        SUBTITLE_FRE="$PARAM_DIRECTORY/$TITLE.fre.$SUBTITLE_EXTENSION"

        if [[ ! -f "$SUBTITLE_ENG" ]] || [[ ! -f "$SUBTITLE_FRE" ]]; then
            echo "English and/or french subtitles are missing."
            continue
        fi

        recode-srt-file.sh "$SUBTITLE_ENG"
        recode-srt-file.sh "$SUBTITLE_FRE"

        VIDEO_ID=$((`mediainfo "$FILE" --inform="Video;%ID%"` - 1))
        AUDIO_ID=$((`mediainfo "$FILE" --inform="Audio;%ID%"` - 1))

        mkvmerge --output "$FILE(1)" --no-attachments --no-track-tags --no-global-tags --no-subtitles --language "$VIDEO_ID":eng --track-name "$VIDEO_ID:$TRACK_NAME" --default-track "$VIDEO_ID":yes --language "$AUDIO_ID":eng --track-name "$AUDIO_ID":Anglais --default-track "$AUDIO_ID":yes "$FILE" --language 0:eng --track-name 0:Anglais "$SUBTITLE_ENG" --language 0:fre --track-name 0:Français --default-track 0:yes "$SUBTITLE_FRE" --title "$TITLE" --track-order 0:"$VIDEO_ID",0:"$AUDIO_ID",1:0,2:0

        if [[ ! -f "$FILE(1)" ]]; then
            echo "An error occurred during the creation of the episode."
            continue
        fi

        rm "$FILE"
        rm "$SUBTITLE_ENG"
        rm "$SUBTITLE_FRE"
        mv "$FILE(1)" "$FILE"

        filebot -rename "$FILE" --format "$FINAL_DIRECTORY/$FILEBOT_FORMAT" --db TheTVDB --lang $LANG --conflict override -non-strict
        echo "The episode was created and moved."
    done
done
exit 0