package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class TvCategories(
    @SerializedName("id")
    val id: String,
    @SerializedName("title")
    val title: String,
    @SerializedName("tvChannels")
    val channels: List<TvChannel>,
) : Serializable