package uz.udevs.udevs_video_player.retrofit

import com.google.gson.GsonBuilder
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitClient {
    fun getRetrofit(baseUrl: String): Retrofit {
        val gson = GsonBuilder().setLenient().create()
        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(gson))
            .baseUrl(baseUrl)
            .build()
    }
}