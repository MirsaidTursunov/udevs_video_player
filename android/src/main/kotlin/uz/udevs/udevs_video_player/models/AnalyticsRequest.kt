package uz.udevs.udevs_video_player.models

data class AnalyticsRequest(
    val episode_key: String? = null,
    val genre: String,
    val movie_key: String,
    val profile_id: String,
    val season_key: String? = null,
    val title: String,
    val user_id: String,
    val video_platform: String
)