package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class TvProgram(
    @SerializedName("scheduledTime")
    val scheduledTime: String,
    @SerializedName("programTitle")
    val programTitle: String,
) : Serializable