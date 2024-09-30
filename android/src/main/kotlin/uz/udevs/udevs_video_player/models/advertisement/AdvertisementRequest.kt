package uz.udevs.udevs_video_player.models.advertisement

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class AdvertisementRequest(
    @SerializedName("device")
    val device: String = "mobile",
    @SerializedName("format")
    val format: String = "player",
    @SerializedName("age")
    val age: Int,
    @SerializedName("gender")
    val gender: String,
    @SerializedName("payment_type")
    val paymentType: String,
    @SerializedName("region")
    val region: String,
    @SerializedName("user_id")
    val userId: String,
) : Serializable