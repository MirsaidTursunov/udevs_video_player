package uz.udevs.udevs_video_player.utils

fun String.toHttps(): String {
    if (this.startsWith("https://")) {
        return this
    }
    return this.replace("http://", "https://")
}