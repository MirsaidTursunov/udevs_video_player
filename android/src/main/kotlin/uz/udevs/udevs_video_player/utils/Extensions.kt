package uz.udevs.udevs_video_player.utils

import uz.udevs.udevs_video_player.models.configuration.PlayerConfiguration

fun String.toHttps(): String {
    if (this.startsWith("https://")) {
        return this
    }
    return this.replace("http://", "https://")
}

fun String.isAutoQuality(playerConfiguration: PlayerConfiguration): Boolean {
    return this == playerConfiguration.autoText
}