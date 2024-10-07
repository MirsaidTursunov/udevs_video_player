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


fun PlayerConfiguration.isUzdMovie(): Boolean {
    return !(this.isMegogo || this.isPremier || this.isMoreTv)
}

fun List<String>.sortQuality(autoText: String): List<String> {
    val sortedQualities = mutableListOf<String>()

    this.forEach {
        if (it.substring(0, it.length - 1).toIntOrNull() != null) {
            sortedQualities.add(it)
        }
    }
    for (i in 0 until sortedQualities.size) {
        for (j in i until sortedQualities.size) {
            val first = sortedQualities[i]
            val second = sortedQualities[j]
            if (first.substring(0, first.length - 1).toInt() < second.substring(
                    0, second.length - 1
                ).toInt()
            ) {
                val a = sortedQualities[i]
                sortedQualities[i] = sortedQualities[j]
                sortedQualities[j] = a
            }
        }
    }
    sortedQualities.add(0, autoText)
    return sortedQualities

}