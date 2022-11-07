package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class Story(
    @SerializedName("id")
    val id: String,
    @SerializedName("title")
    val title: String,
    @SerializedName("fileName")
    val fileName: String,
    @SerializedName("quality")
    val quality: String,
    @SerializedName("duration")
    val duration: Long,
    @SerializedName("slug")
    var slug: String,
    @SerializedName("is_watched")
    var isWatched: Boolean,
    @SerializedName("is_amediateka")
    var isAmediateka: Boolean,
) : Serializable