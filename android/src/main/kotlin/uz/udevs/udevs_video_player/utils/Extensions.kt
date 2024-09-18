package uz.udevs.udevs_video_player.utils

import androidx.media3.common.util.Log
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer

fun String.toHttps(): String {
    if (this.startsWith("https://")) {
        return this
    }
    return this.replace("http://", "https://")
}


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

fun ExoPlayer.changeAudioLanguage(lang: String) {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredAudioLanguage(lang).build()
}

fun ExoPlayer.changeSubtitle(subtitle: String) {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredTextLanguage(subtitle).build()
}

fun ExoPlayer.hideSubtitle() {
    this.trackSelectionParameters =
        this.trackSelectionParameters.buildUpon().setPreferredTextLanguage(null).build()
}


fun String?.ifNullOrEmpty(default: String): String {
    if (this.isNullOrEmpty()) {
        return default
    }
    return this
}