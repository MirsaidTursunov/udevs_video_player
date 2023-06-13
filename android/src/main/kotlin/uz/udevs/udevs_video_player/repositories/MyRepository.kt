//package uz.udevs.udevs_video_player.repositories
//
//import androidx.lifecycle.LiveData
//import androidx.lifecycle.MutableLiveData
//import retrofit2.Call
//import retrofit2.Callback
//import retrofit2.Response
//import uz.udevs.udevs_video_player.models.MegogoStreamResponse
//import uz.udevs.udevs_video_player.models.PremierStreamResponse
//import uz.udevs.udevs_video_player.retrofit.Common
//import uz.udevs.udevs_video_player.retrofit.RetrofitService
//
//class MyRepository {
//
//    private var retrofitService: RetrofitService = Common.retrofitService()
//
//    fun getMegogoStream(
//        authorization: String,
//        sessionId: String,
//        videoId: String,
//        accessToken: String,
//    ): LiveData<MegogoStreamResponse> {
//        val data = MutableLiveData<MegogoStreamResponse>()
//        retrofitService.getMegogoStream(authorization,sessionId, videoId, accessToken)
//            .enqueue(object : Callback<MegogoStreamResponse> {
//                override fun onResponse(
//                    call: Call<MegogoStreamResponse>,
//                    response: Response<MegogoStreamResponse>
//                ) {
//                    data.value = response.body()
//                }
//
//                override fun onFailure(call: Call<MegogoStreamResponse>, t: Throwable) {
//                    data.value = null
//                }
//            })
//        return data
//    }
//
//    fun getPremierStream(
//        authorization: String,
//        sessionId: String,
//        videoId: String,
//        episodeId: String,
//    ): LiveData<PremierStreamResponse> {
//        val data = MutableLiveData<PremierStreamResponse>()
//        retrofitService.getPremierStream(authorization, sessionId, videoId, episodeId)
//            .enqueue(object : Callback<PremierStreamResponse> {
//                override fun onResponse(
//                    call: Call<PremierStreamResponse>,
//                    response: Response<PremierStreamResponse>
//                ) {
//                    data.value = response.body()
//                }
//
//                override fun onFailure(call: Call<PremierStreamResponse>, t: Throwable) {
//                    data.value = null
//                }
//            })
//        return data
//    }
//}