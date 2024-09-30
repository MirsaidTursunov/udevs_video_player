package uz.udevs.udevs_video_player.models.advertisement

import com.google.gson.annotations.SerializedName
import java.io.Serializable
data class AdvertisementAnalyticsRequest(
    val id: String,
    val click: Boolean,
    val interested: Boolean,
    @SerializedName("view_time")
    val viewTime: Int,
): Serializable