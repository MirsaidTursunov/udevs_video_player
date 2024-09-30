package uz.udevs.udevs_video_player.models.response

data class PremierStreamResponse(
    val file_info: List<FileInfo?>?
) {
    data class FileInfo(
        val quality: String?,
        val file_name: String?,
        val duration: Int?,
        val width: Int?,
        val height: Int?
    )
}