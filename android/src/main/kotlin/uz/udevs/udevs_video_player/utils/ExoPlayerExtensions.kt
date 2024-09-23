package uz.udevs.udevs_video_player.utils

import androidx.media3.common.TrackSelectionOverride
import androidx.media3.common.util.Log
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer

// quality
fun ExoPlayer.getAvailableQualities(): ArrayList<String> {
    val tracks = this.currentTracks.groups
    val formats: MutableList<String> = mutableListOf()
    for (trackGroup in tracks) {
        if (trackGroup.isSupported) {
            for (i in 0 until trackGroup.length) {
                val isSupported = trackGroup.isTrackSupported(i)
                val trackFormat = trackGroup.getTrackFormat(i).height.toString() + "p"
                if (isSupported && trackFormat != "p" && trackFormat != "-1p" && !formats.contains(
                        trackFormat
                    )
                ) {
                    formats.add(trackFormat)
                }
            }
        }
    }
    return formats.reversed().toCollection(ArrayList())
}

fun ExoPlayer.changeVideoQuality(
    index: Int,
    numberOfQualities: Int,
) {
    this.trackSelectionParameters = this.trackSelectionParameters.buildUpon().setOverrideForType(
        TrackSelectionOverride(
            this.currentTracks.groups[0].mediaTrackGroup, numberOfQualities - index - 1
        )
    ).build()
}

// audio language
@UnstableApi
fun ExoPlayer.getAvailableAudioLanguages(): List<String> {
    val tracks = this.currentTracks.groups
    val languages: MutableList<String> = mutableListOf()
    for (trackGroup in tracks) {
        val id = trackGroup.mediaTrackGroup.id
        Log.i("TAG", "getAvailableLanguages: $id")
        if (id.contains("audio")) {
            languages.add(id.replace("audio:", ""))
        }
    }
    return languages
}

fun ExoPlayer.changeAudioLanguage(lang: String) {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredAudioLanguage(lang).build()
}

// subtitle
@UnstableApi
fun ExoPlayer.getAvailableSubtitles(): List<String> {
    val tracks = this.currentTracks.groups
    val subtitles: MutableList<String> = mutableListOf()
    for (trackGroup in tracks) {
        val id = trackGroup.mediaTrackGroup.id
        Log.d("TAG", "getAvailableSubtitles: $id")
        if (id.contains("subtitle")) {
            subtitles.add(id.replace("subtitle:", "").split(":").last())
        }
    }
    return subtitles
}

fun ExoPlayer.changeSubtitle(subtitle: String) {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredTextLanguage(subtitle).build()
}

fun ExoPlayer.hideSubtitle() {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredTextLanguage(null).build()
}
