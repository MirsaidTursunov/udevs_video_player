package uz.udevs.udevs_video_player.data_source

import android.content.Context
import android.net.Uri
import androidx.annotation.OptIn
import androidx.media3.common.util.Log
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DataSpec
import androidx.media3.datasource.TransferListener

// val mediaItem = MediaItem.fromUri("https://cdn.uzd.udevs.io/uzdigital/videos/1d05200c7abae0817ca7545f4ac7a63a/master.m3u8")
//                        val defaultDataSourceFactory = DefaultDataSource.Factory(context)
//
//                        val hlsMediaSourceFactory = HlsMediaSource.Factory(
//                            uz.udevs.udevs_video_player.data_source.CustomHlsDataSourceFactory(context, defaultDataSourceFactory)
//                        ).createMediaSource(mediaItem)
/// setMediaSource(hlsMediaSourceFactory)
class CustomHlsDataSourceFactory(
    private val context: Context, private val defaultDataSourceFactory: DataSource.Factory
) : DataSource.Factory {

    @UnstableApi
    override fun createDataSource(): DataSource {
        return CustomHlsDataSource(context, defaultDataSourceFactory.createDataSource())
    }
}

class CustomHlsDataSource(
    private val context: Context, private val upstreamDataSource: DataSource
) : DataSource {

    @UnstableApi
    override fun open(dataSpec: DataSpec): Long {
        val uri = dataSpec.uri.toString()

        if (uri.endsWith("_")) {
            Log.d("Incorrect uri", "before $uri")
            val newDataSpec =
                dataSpec.buildUpon().setUri((Uri.parse("${uri}\"MVO/index.m3u8"))).build()
            Log.d("Incorrect uri", "after ${newDataSpec.uri}")
            return upstreamDataSource.open(newDataSpec)
        }

        return upstreamDataSource.open(dataSpec)
    }

    @UnstableApi
    override fun read(buffer: ByteArray, offset: Int, readLength: Int): Int {
        return upstreamDataSource.read(buffer, offset, readLength)
    }

    @UnstableApi
    override fun addTransferListener(transferListener: TransferListener) {
        return upstreamDataSource.addTransferListener(transferListener)
    }

    @OptIn(UnstableApi::class)
    override fun getUri(): Uri? {
        return upstreamDataSource.uri
    }

    @UnstableApi
    override fun close() {
        upstreamDataSource.close()
    }
}