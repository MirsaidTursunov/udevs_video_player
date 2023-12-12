package uz.udevs.udevs_video_player.models

data class MoreTvStreamResponse(
    val data: Data,
) {
    data class Data(
        val ad_tag_url: Any,
        val audio: Any,
        val duration: Int,
        val expire: Int,
        val id: Int,
        val ip: String,
        val mime_type: String,
        val quality: String,
        val url: String
    )
}