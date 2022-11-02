package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

class MovieTrack(
    @SerializedName("episode_key")
    val episodeKey: String,
    @SerializedName("is_megogo")
    val isMegogo: Boolean,
    @SerializedName("movie_key")
    val movieKey: String,
    @SerializedName("season_key")
    val seasonKey: String,
    @SerializedName("seconds")
    val seconds: Int,
    @SerializedName("user_id")
    val userId: String,
    @SerializedName("element")
    val element: String,
) : Serializable