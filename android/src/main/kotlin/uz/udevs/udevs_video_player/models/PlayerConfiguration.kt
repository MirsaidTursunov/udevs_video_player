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
    @SerializedName("lastPosition")
    val lastPosition: Long,
    @SerializedName("title")
    val title: String,
    @SerializedName("storyButtonText")
    val storyButtonText: String,
    @SerializedName("closeText")
    val closeText: String,
    @SerializedName("episodeButtonText")
    val episodeButtonText: String,
    @SerializedName("nextButtonText")
    val nextButtonText: String,
    @SerializedName("seasons")
    val seasons: List<Season>,
    @SerializedName("story")
    val story: List<Story>,
    @SerializedName("tvProgramsText")
    val tvProgramsText: String,
    @SerializedName("programsInfoList")
    val programsInfoList: List<ProgramsInfo>,
    @SerializedName("showController")
    val showController: Boolean,
    @SerializedName("playVideoFromAsset")
    val playVideoFromAsset: Boolean,
    @SerializedName("assetPath")
    val assetPath: String,
    @SerializedName("seasonIndex")
    val seasonIndex: Int,
    @SerializedName("episodeIndex")
    val episodeIndex: Int,
    @SerializedName("storyIndex")
    val storyIndex: Int,
    @SerializedName("isMegogo")
    val isMegogo: Boolean,
    @SerializedName("isPremier")
    val isPremier: Boolean,
    @SerializedName("videoId")
    val videoId: String,
    @SerializedName("sessionId")
    val sessionId: String,
    @SerializedName("megogoAccessToken")
    val megogoAccessToken: String,
    @SerializedName("authorization")
    val authorization: String,
    @SerializedName("autoText")
    val autoText: String,
    @SerializedName("baseUrl")
    val baseUrl: String,
    @SerializedName("type")
    val type: PlayerType,
    @SerializedName("platform")
    val platform: String,
    @SerializedName("movieTrack")
    val movieTrack: MovieTrack,
    @SerializedName("userId")
    val userId: String,
) : Serializable

