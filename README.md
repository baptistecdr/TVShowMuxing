# TVShowMuxing

TVShowMuxing adds the English and French subtitles in one or more episodes of a series.
It also renames the MKV file, subtitles, and tracks content in the MKV file. All this will make it 100% compatible with Plex or Kodi.

# Requirements :

To allow the script to function perfectly, you need to have installed the software :

*   [FileBot](http://www.filebot.net/)
*   [MKVToolNix](https://mkvtoolnix.download/)
*   [MediaInfo](https://mediaarea.net/fr/MediaInfo/Download)
*   Recode (apt-get install recode)
*   Dos2unix (apt-get install dos2unix)

**You must also modify the final record where the file will be move :  [tvshow-muxing.sh](https://github.com/baptistecdr/TVShowMuxing/blob/master/tvshow-muxing.sh#L7).**


# Example :

Consider a folder containing an episode with it subtitles :

*   Suits.S06E07.720p.HDTV.x264-KILLERS
    *   Suits - 06x07 - Shake the Trees.KILLERS.English.C.updated.Addic7ed.com.srt
    *   Suits - 06x07 - Shake the Trees.KILLERS.French.C.updated.Addic7ed.com.srt
    *   Suits.S06E07.720p.HDTV.x264-KILLERS.mkv

And an other folder :
*   Suits.S06E08.720p.HDTV.x264-KILLERS
    *   Suits - 06x08 - Borrowed Time.KILLERS.English.C.updated.Addic7ed.com.srt
    *   Suits - 06x08 - Borrowed Time.KILLERS.French.C.updated.Addic7ed.com.srt
    *   Suits.S06E08.720p.HDTV.x264-KILLERS.mkv

The command to execute will be : tvshow-muxing.sh Suits.S06E07.720p.HDTV.x264-KILLERS/ Suits.S06E08.720p.HDTV.x264-KILLERS/





