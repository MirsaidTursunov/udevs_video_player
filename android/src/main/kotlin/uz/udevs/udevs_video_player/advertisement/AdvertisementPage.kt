package uz.udevs.udevs_video_player.advertisement

import android.annotation.SuppressLint
import android.media.session.PlaybackState
import android.util.Log
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import coil.compose.SubcomposeAsyncImage
import coil.request.ImageRequest
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import uz.udevs.udevs_video_player.advertisement.components.LoadingIndicator
import uz.udevs.udevs_video_player.models.AdvertisementResponse

class AdvertisementPage(
    private val advertisement: AdvertisementResponse,
    private val skipText: String,
    private val onFinish: () -> Unit,
) {

    private var indicatorFlow: Flow<Float>? = null
    private var isImageLoaded: Boolean = false

    private var exoPlayer: ExoPlayer? = null
    private fun startIndicatorTimer() {
        Log.i("", "startIndicatorTimer")
        val skipDuration = advertisement.skipDuration ?: 15
        indicatorFlow = flow {
            var percent = 0
            while (percent < 500) {
                Log.i("", "startIndicatorTimer in while")
                delay((skipDuration * 2).toLong())
                /// if image advertisement
                if (advertisement.video.isNullOrEmpty() && isImageLoaded) {
                    percent++
                    emit(percent * 0.002f)
                } else {
                    /// if video advertisement
                    Log.i("", "isPlaying = ${exoPlayer?.isPlaying}")
                    if (exoPlayer?.isPlaying == true) {
                        percent++
                        emit(percent * 0.002f)
                    }
                }
                Log.i("", "startIndicatorTimer emitted ${percent * 0.002f}")
            }
            if (percent == 500 && advertisement.video == null) {
                onFinish.invoke()
            }
        }
    }

    @SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
    @Composable
    fun Content() {
        val uriHandler = LocalUriHandler.current
        if (indicatorFlow == null) {
            startIndicatorTimer()
        }

        Box(modifier = Modifier
            .clickable { uriHandler.openUri(advertisement.link ?: "") }
            .fillMaxSize()
            .background(Color.Black)) {
            if (advertisement.video.isNullOrEmpty())
                SubcomposeAsyncImage(
                    modifier = Modifier
                        .fillMaxSize()
                        .align(Alignment.Center),
                    model = ImageRequest.Builder(LocalContext.current)
                        .data(
                            (advertisement.bannerImage?.mobileImage ?: "").ifEmpty {
                                advertisement.bannerImage?.webImage ?: ""
                            }.ifEmpty { advertisement.bannerImage?.tvImage ?: "" },
                        ).crossfade(true).build(),
                    loading = {
                        LoadingIndicator(isLoading = true)
                    },
                    onSuccess = { isImageLoaded = true },
                    contentDescription = "",
                )
            else VideoPlayer(
                videoUrl = advertisement.video,
                onFinish = onFinish,
            )
            Box(
                modifier = Modifier
                    .fillMaxHeight()
                    .width(LocalConfiguration.current.screenWidthDp.dp / 2)
                    .background(
                        Brush.horizontalGradient(
                            colors = listOf(Color.Black.copy(0.3f), Color.Transparent),
                        ),
                    )
            )
//            Box(
//                modifier = Modifier
//                    .fillMaxWidth()
//                    .height(LocalConfiguration.current.screenHeightDp.dp / 6)
//                    .background(
//                        Brush.verticalGradient(
//                            colors = listOf(Color.Black.copy(0.3f), Color.Transparent),
//                        ),
//                    )
//            )
//            Box(
//                modifier = Modifier
//                    .fillMaxWidth()
//                    .align(Alignment.BottomCenter)
//                    .height(LocalConfiguration.current.screenHeightDp.dp / 6)
//                    .background(
//                        Brush.verticalGradient(
//                            colors = listOf(Color.Transparent, Color.Black),
//                        ),
//                    )
//            )
            val indicatorPercentage = indicatorFlow?.collectAsState(initial = 0f)
            AnimatedVisibility(
                visible = indicatorPercentage?.value != 1f,
                enter = fadeIn(),
                exit = fadeOut(),
            ) {
                LinearProgressIndicator(
                    progress = { indicatorPercentage?.value ?: 0f },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 16.dp, end = 16.dp, top = 20.dp)
                        .height(4.dp)
                        .clip(RoundedCornerShape(12.dp)),
                    strokeCap = StrokeCap.Round,
                    trackColor = Color.White.copy(0.7f),
                    color = MaterialTheme.colorScheme.primary,
                )
            }

            AnimatedVisibility(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .padding(bottom = 20.dp),
                visible = indicatorPercentage?.value == 1f,
                enter = fadeIn(),
                exit = fadeOut(),
            ) {
                Button(
                    shape = RoundedCornerShape(12.dp),
                    onClick = onFinish,
                    colors = ButtonDefaults.buttonColors().copy(
                        containerColor = MaterialTheme.colorScheme.secondary
                    ),
                ) {
                    Text(
                        modifier = Modifier.padding(vertical = 8.dp, horizontal = 24.dp),
                        text = skipText,
                        style = MaterialTheme.typography.labelSmall.copy(
                            fontSize = 16.sp,
                        )
                    )
                }
            }
        }
    }

    @Composable
    private fun VideoPlayer(
        videoUrl: String, onFinish: () -> Unit
    ) {
        val context = LocalContext.current
        var isLoading by remember { mutableStateOf(false) }
        var playbackState by remember { mutableIntStateOf(0) }

        exoPlayer = remember {
            ExoPlayer.Builder(context).build().apply {
                setMediaItem(MediaItem.Builder().apply {
                    setUri(
                        videoUrl
                    )
                }.build())
                prepare()
                seekTo(0)
                playWhenReady = true
            }
        }


        DisposableEffect(key1 = Unit) {
            val listener = object : Player.Listener {
                var stopped: Boolean = false
                override fun onEvents(
                    player: Player, events: Player.Events
                ) {
                    super.onEvents(player, events)
                    playbackState = player.playbackState
                    isLoading = player.isLoading
                    if (playbackState == 4 && !stopped) {
                        stopped = true
                        Log.i("tv advertisement", "video finished")
                        onFinish.invoke()
                    }
                }
            }
            exoPlayer?.addListener(listener)

            onDispose {
                exoPlayer?.removeListener(listener)
                exoPlayer?.release()
            }
        }


        AndroidView(
            factory = {
                PlayerView(context).apply {
                    player = exoPlayer
                    useController = false
                    layoutParams = FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT
                    )
                }
            },
        )

        LoadingIndicator(
            isLoading = isLoading && playbackState != PlaybackState.STATE_PLAYING,
        )
    }
}