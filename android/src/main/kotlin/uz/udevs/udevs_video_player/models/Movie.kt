package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class Movie(
    @SerializedName("title")
    val title: String,
    @SerializedName("description")
    val description: String,
    @SerializedName("image")
    val image: String,
    @SerializedName("resolutions")
    val resolutions: HashMap<String, String>
) : Serializable