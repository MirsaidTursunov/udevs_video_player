package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class AdvertisementResponse(
    @SerializedName("id")
    val id: String?,
    @SerializedName("banner_image")
    val bannerImage: BannerImage?,
    @SerializedName("link")
    val link: String?,
    @SerializedName("skip_duration")
    val skipDuration: Int?,
    @SerializedName("video")
    val video: String?,
) : Serializable