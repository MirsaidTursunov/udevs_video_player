package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class CheckAnalyticsRequest(

    @SerializedName("episode_key")
    val episodeKey: String,
    @SerializedName("is_story")
    val isStory: Boolean,
    @SerializedName("movie_key")
    val movieKey: String,
    @SerializedName("season_key")
    val seasonKey: String,
    @SerializedName("user_id")
    val userId: String,
    @SerializedName("video_platform")
    val videoPlatform: String,
) : Serializable