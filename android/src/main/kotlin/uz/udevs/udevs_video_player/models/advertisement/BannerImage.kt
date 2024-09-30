package uz.udevs.udevs_video_player.models.advertisement

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class BannerImage(
    @SerializedName("mobile_image") val mobileImage: String?,
    @SerializedName("tv_image") val tvImage: String?,
    @SerializedName("web_image") val webImage: String?,
) : Serializable