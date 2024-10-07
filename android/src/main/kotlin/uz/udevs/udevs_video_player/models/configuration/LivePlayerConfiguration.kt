package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import uz.udevs.udevs_video_player.models.advertisement.AdvertisementResponse
import java.io.Serializable

data class LivePlayerConfiguration(
    @SerializedName("videoUrl") val videoUrl: String,
    @SerializedName("qualityText") val qualityText: String,
    @SerializedName("speedText") val speedText: String,
    @SerializedName("title") val title: String,
    @SerializedName("advertisement") val advertisement: AdvertisementResponse?,
    @SerializedName("tvProgramsText") val tvProgramsText: String,
    @SerializedName("programsInfoList") val programsInfoList: List<ProgramsInfo>,
    @SerializedName("showController") val showController: Boolean,
    @SerializedName("authorization") val authorization: String,
    @SerializedName("autoText") val autoText: String,
    @SerializedName("baseUrl") val baseUrl: String,
    @SerializedName("tvCategories") val tvCategories: List<TvCategories>,
    @SerializedName("ip") val ip: String,
    @SerializedName("selectChannelIndex") val selectChannelIndex: Int,
    @SerializedName("selectTvCategoryIndex") val selectTvCategoryIndex: Int,
    @SerializedName("skipText") val skipText: String,
    @SerializedName("userId") val userId: String,
    @SerializedName("age") val age: Int,
    @SerializedName("gender") val gender: String,
    @SerializedName("region") val region: String,
) : Serializable
