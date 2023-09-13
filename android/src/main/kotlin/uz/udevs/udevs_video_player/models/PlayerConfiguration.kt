package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class PlayerConfiguration(
    @SerializedName("initialResolution")
    val initialResolution: HashMap<String, String>,
    @SerializedName("resolutions")
    val resolutions: HashMap<String, String>,
    @SerializedName("qualityText")
    val qualityText: String,
    @SerializedName("speedText")
    val speedText: String,
    @SerializedName("programsText")
    val programsText: String,
    @SerializedName("lastPosition")
    val lastPosition: Long,
    @SerializedName("title")
    val title: String,
    @SerializedName("isSerial")
    val isSerial: Boolean,
    @SerializedName("seasons")
    val seasons: List<Season>,
    @SerializedName("isYoutube")
    val isYoutube: Boolean,
    @SerializedName("showController")
    val showController: Boolean,
    @SerializedName("assetPath")
    val assetPath: String,
    @SerializedName("seasonIndex")
    val seasonIndex: Int,
    @SerializedName("episodeIndex")
    val episodeIndex: Int,
    @SerializedName("episodeText")
    val episodeText: String,
    @SerializedName("seasonText")
    val seasonText: String,
    @SerializedName("videoId")
    val videoId: String,
    @SerializedName("sessionId")
    val sessionId: String,
    @SerializedName("authorization")
    val authorization: String,
    @SerializedName("autoText")
    val autoText: String,
    @SerializedName("baseUrl")
    val baseUrl: String,
) : Serializable