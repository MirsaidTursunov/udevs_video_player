package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class Season(
    @SerializedName("title")
    val title: String,
    @SerializedName("movies")
    val movies: List<Movie>,
) : Serializable