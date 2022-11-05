package uz.udevs.udevs_video_player.retrofit

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query
import uz.udevs.udevs_video_player.models.*

interface RetrofitService {

    @GET("megogo/stream")
    fun getMegogoStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Query("video_id") videoId: String,
        @Query("access_token") megogoAccessToken: String,
    ): Call<MegogoStreamResponse>

    @GET("premier/videos/{video-id}/episodes/{episode-id}/stream")
    fun getPremierStream(
        @Header("Authorization") authorization: String,
        @Header("SessionId") sessionId: String,
        @Path("video-id") videoId: String,
        @Path("episode-id") episodeId: String,
    ): Call<PremierStreamResponse>

    @POST("movie-track")
    fun postMovieTrack(
        @Header("Authorization") authorization: String,
        @Header("platform") platform: String,
        @Body movieTrack: MovieTrack,
    ): Call<MovieTrackResponse>

    @POST("analytics")
    fun postStoryAnalytics(
        @Body analyticsRequest: CheckAnalyticsRequest,
    ): Call<CheckAnalyticsResponse>
}