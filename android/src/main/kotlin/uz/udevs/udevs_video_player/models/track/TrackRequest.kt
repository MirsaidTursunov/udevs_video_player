package uz.udevs.udevs_video_player.models.track


import com.google.gson.annotations.SerializedName

data class TrackRequest(
    @SerializedName("duration")
    val duration: Int = 0,
    @SerializedName("element")
    val element: String = "",
    @SerializedName("episode_id")
    val episodeId: String = "",
    @SerializedName("episode_key")
    val episodeKey: String = "",
    @SerializedName("is_megogo")
    val isMegogo: Boolean = false,
    @SerializedName("is_premier")
    val isPremier: Boolean = false,
    @SerializedName("movie_key")
    val movieKey: String = "",
    @SerializedName("profile_id")
    val profileId: String = "",
    @SerializedName("season_key")
    val seasonKey: String = "",
    @SerializedName("seconds")
    val seconds: Int = 0,
    @SerializedName("user_id")
    val userId: String = ""
)