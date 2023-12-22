package uz.udevs.udevs_video_player.utils

import android.util.Log
import androidx.media3.common.TrackSelectionOverride
import androidx.media3.common.Tracks
import androidx.media3.exoplayer.ExoPlayer
import java.util.ArrayList

class MyHelper {

    fun isVideoLink(link: String): Boolean {
        // Define a regular expression for common video file extensions
        val videoFileExtensions = listOf("mp4", "avi", "mkv", "mov", "wmv", "flv", "webm")

        // Extract the file extension from the link
        val fileExtension = link.substringAfterLast('.', "")

        // Check if the file extension is in the list of video file extensions
        return videoFileExtensions.contains(fileExtension.toLowerCase())
    }


    fun formatDuration(duration: Long): String {
        var seconds = duration
        val hours: Int = (seconds / 3600).toInt()
        seconds %= 3600
        val minutes: Int = (seconds / 60).toInt()
        seconds %= 60

        val hoursString = if (hours >= 10)
            "$hours" else
            if (hours == 0)
                "00"
            else "0$hours"

        val minutesString = if (minutes >= 10)
            "$minutes" else
            if (minutes == 0)
                "00"
            else "0$minutes"

        val secondsString = if (seconds >= 10)
            "$seconds"
        else if (seconds.toInt() == 0)
            "00"
        else "0$seconds"

        return "${if (hoursString == "00") "" else "$hoursString:"}$minutesString:$secondsString"
    }

    fun getAvailableFormatsFromMoreTv(
        tracks: List<Tracks.Group>
    ): ArrayList<String> {
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

    fun changeVideoQuality(
        exoPlayer: ExoPlayer,
        index: Int,
        numberOfQualities: Int,
    ) {
        exoPlayer.trackSelectionParameters =
            exoPlayer.trackSelectionParameters
                .buildUpon()
                .setOverrideForType(
                    TrackSelectionOverride(
                        exoPlayer.currentTracks.groups[0].mediaTrackGroup,
                        numberOfQualities - index - 1
                    )
                )
                .build()
    }
}