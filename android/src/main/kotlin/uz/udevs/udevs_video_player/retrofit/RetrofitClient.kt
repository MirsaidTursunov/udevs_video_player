package uz.udevs.udevs_video_player.retrofit

import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitClient {
    fun getRetrofit(baseUrl: String): Retrofit {
        val gson = GsonBuilder().setLenient().create()
        val logging = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
        val client =
            OkHttpClient.Builder().addInterceptor(logging).readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS).callTimeout(30, TimeUnit.SECONDS).build()
        return Retrofit.Builder().addConverterFactory(GsonConverterFactory.create(gson))
            .baseUrl(baseUrl).client(client).build()
    }
}