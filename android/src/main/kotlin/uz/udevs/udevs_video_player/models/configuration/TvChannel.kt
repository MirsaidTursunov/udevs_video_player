package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class TvChannel(
    @SerializedName("id")
    val id: String,
    @SerializedName("image")
    val image: String,
    @SerializedName("name")
    val name: String,
    @SerializedName("resolutions")
    var resolutions: HashMap<String, String>,
    @SerializedName("paymentType")
    var paymentType: String,
    @SerializedName("hasAccess")
    var hasAccess: Boolean,
) : Serializable