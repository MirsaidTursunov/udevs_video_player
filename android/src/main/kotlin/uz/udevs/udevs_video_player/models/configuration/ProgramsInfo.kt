package uz.udevs.udevs_video_player.models.configuration

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class ProgramsInfo(
    @SerializedName("day")
    val day: String,
    @SerializedName("tvPrograms")
    val tvPrograms: List<TvProgram>,
) : Serializable