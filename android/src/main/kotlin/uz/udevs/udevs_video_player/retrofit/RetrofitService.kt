package uz.udevs.udevs_video_player.retrofit

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path
import retrofit2.http.Query
import uz.udevs.udevs_video_player.models.MegogoStreamResponse
import uz.udevs.udevs_video_player.models.MoreTvStreamResponse
import uz.udevs.udevs_video_player.models.PremierStreamResponse
import uz.udevs.udevs_video_player.models.TvChannelResponse

interface RetrofitService {

    @GET("megogo/stream")
    fun getMegogoStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Query("video_id") videoId: String,
        @Query("access_token") megogoAccessToken: String,
    ): Call<MegogoStreamResponse>

    @GET("moretv/play/{video-id}")
    fun getMoreTvStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Path("video-id") videoId: String,
    ): Call<MoreTvStreamResponse>

    @GET("premier/videos/{video-id}/episodes/{episode-id}/stream")
    fun getPremierStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Path("video-id") videoId: String,
        @Path("episode-id") episodeId: String,
    ): Call<PremierStreamResponse>

    @GET("tv/channel/{id}")
    fun getSingleTvChannel(
        @Header("Authorization") authorization: String,
        @Path("id") id: String,
        @Query("client_ip") clientIp: String,
    ): Call<TvChannelResponse>


    @GET("ping-online-users")
    fun sentOnlineUserInfo(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Query("profile_id") profileId: String,
        @Query("movie_id") movieId: String,
        @Query("movie_title") movieTitle: String,
    ): Call<Any>


}