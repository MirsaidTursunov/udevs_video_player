package uz.udevs.udevs_video_player.retrofit

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path
import retrofit2.http.Query
import uz.udevs.udevs_video_player.models.advertisement.AdvertisementAnalyticsRequest
import uz.udevs.udevs_video_player.models.advertisement.AdvertisementRequest
import uz.udevs.udevs_video_player.models.advertisement.AdvertisementResponse
import uz.udevs.udevs_video_player.models.AnalyticsRequest
import uz.udevs.udevs_video_player.models.response.MegogoStreamResponse
import uz.udevs.udevs_video_player.models.response.MoreTvStreamResponse
import uz.udevs.udevs_video_player.models.response.PremierStreamResponse
import uz.udevs.udevs_video_player.models.response.TvChannelResponse
import uz.udevs.udevs_video_player.models.track.TrackRequest

interface RetrofitService {
    @GET("megogo/stream")
    fun getMegogoStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Query("video_id") videoId: String,
        @Query("access_token") megogoAccessToken: String,
    ): Call<MegogoStreamResponse>

    @POST("analytics")
    fun sendAnalytics(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Body body: AnalyticsRequest,
    ): Call<Any>

    @POST("movie-track")
    fun sendMovieTrack(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Body request: TrackRequest,
    ): Call<Any>


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

    @POST("advertisingTest")
    fun getAdvertisement(
        @Body request: AdvertisementRequest
    ): Call<AdvertisementResponse>

    @PUT("advertisingTest")
    fun sendAdvertisementAnalytics(
        @Body request: AdvertisementAnalyticsRequest
    ): Call<Any>

}