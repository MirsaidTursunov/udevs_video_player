package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.PictureInPictureParams
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Color
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.Rational
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ListView
import android.widget.ProgressBar
import android.widget.RelativeLayout
import android.widget.SeekBar
import android.widget.SeekBar.OnSeekBarChangeListener
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerControlView
import androidx.media3.ui.PlayerView
import androidx.media3.ui.PlayerView.SHOW_BUFFERING_ALWAYS
import androidx.media3.ui.PlayerView.SHOW_BUFFERING_NEVER
import androidx.mediarouter.app.MediaRouteButton
import androidx.viewpager2.widget.ViewPager2
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaLoadRequestData
import com.google.android.gms.cast.MediaMetadata
import com.google.android.gms.cast.MediaSeekOptions
import com.google.android.gms.cast.framework.CastButtonFactory
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.CastSession
import com.google.android.gms.cast.framework.SessionManagerListener
import com.google.android.gms.cast.framework.media.RemoteMediaClient
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.adapters.EpisodePagerAdapter
import uz.udevs.udevs_video_player.adapters.QualitySpeedAdapter
import uz.udevs.udevs_video_player.adapters.TvCategoryPagerAdapter
import uz.udevs.udevs_video_player.adapters.TvProgramsPagerAdapter
import uz.udevs.udevs_video_player.models.AnalyticsRequest
import uz.udevs.udevs_video_player.models.BottomSheet
import uz.udevs.udevs_video_player.models.MegogoStreamResponse
import uz.udevs.udevs_video_player.models.MoreTvStreamResponse
import uz.udevs.udevs_video_player.models.PlayerConfiguration
import uz.udevs.udevs_video_player.models.PremierStreamResponse
import uz.udevs.udevs_video_player.models.TvChannelResponse
import uz.udevs.udevs_video_player.models.isUzdMovie
import uz.udevs.udevs_video_player.retrofit.Common
import uz.udevs.udevs_video_player.retrofit.RetrofitService
import uz.udevs.udevs_video_player.services.DownloadUtil
import uz.udevs.udevs_video_player.services.NetworkChangeReceiver
import uz.udevs.udevs_video_player.utils.MyHelper
import uz.udevs.udevs_video_player.utils.changeAudioLanguage
import uz.udevs.udevs_video_player.utils.changeSubtitle
import uz.udevs.udevs_video_player.utils.changeVideoQuality
import uz.udevs.udevs_video_player.utils.getAvailableAudioLanguages
import uz.udevs.udevs_video_player.utils.getAvailableQualities
import uz.udevs.udevs_video_player.utils.getAvailableSubtitles
import uz.udevs.udevs_video_player.utils.hideSubtitle
import uz.udevs.udevs_video_player.utils.isAutoQuality
import uz.udevs.udevs_video_player.utils.removeSeasonEpisode
import uz.udevs.udevs_video_player.utils.toHttps
import java.util.Timer
import kotlin.concurrent.timerTask
import kotlin.math.abs

@UnstableApi
class UdevsVideoPlayerActivity : AppCompatActivity(), GestureDetector.OnGestureListener,
    ScaleGestureDetector.OnScaleGestureListener, AudioManager.OnAudioFocusChangeListener {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private lateinit var networkChangeReceiver: NetworkChangeReceiver
    private lateinit var intentFilter: IntentFilter
    private lateinit var playerConfiguration: PlayerConfiguration
    private var close: ImageView? = null
    private var pip: ImageView? = null
    private var cast: MediaRouteButton? = null
    private var shareMovieLinkIv: ImageView? = null
    private var more: ImageView? = null
    private var title: TextView? = null
    private var title1: TextView? = null
    private var rewind: ImageView? = null
    private var forward: ImageView? = null
    private var playPause: ImageView? = null
    private var progressbar: ProgressBar? = null
    private var timer: LinearLayout? = null
    private var exoPosition: TextView? = null
    private var videoPosition: TextView? = null
    private var live: LinearLayout? = null
    private var episodesButton: LinearLayout? = null
    private var episodesText: TextView? = null
    private var nextButtonHeight: CardView? = null
    private var nextButton: CardView? = null
    private var nextText: TextView? = null
    private var tvProgramsButton: ImageView? = null
    private var tvChannels: ImageView? = null
    private var tvChannelsButton: LinearLayout? = null
    private var zoom: ImageView? = null
    private var orientation: ImageView? = null
    private var subtitleButton: ImageView? = null
    private var exoProgress: DefaultTimeBar? = null
    private var customSeekBar: SeekBar? = null
    private var customPlayback: RelativeLayout? = null
    private var layoutBrightness: LinearLayout? = null
    private var brightnessSeekbar: SeekBar? = null
    private var volumeSeekBar: SeekBar? = null
    private var layoutVolume: LinearLayout? = null
    private var audioManager: AudioManager? = null
    private var gestureDetector: GestureDetector? = null
    private var scaleGestureDetector: ScaleGestureDetector? = null
    private var isSettingsBottomSheetOpened: Boolean = false
    private var isQualitySpeedBottomSheetOpened: Boolean = false
    private val listOfAllOpenedBottomSheets = mutableListOf<BottomSheetDialog>()
    private var brightness: Double = 15.0
    private var maxBrightness: Double = 31.0
    private var volume: Double = 0.0
    private var maxVolume: Double = 0.0
    private var sWidth: Int = 0
    private var seasonIndex: Int = 0
    private var episodeIndex: Int = 0
    private var retrofitService: RetrofitService? = null
    private val tag = "UdevsVideoPlayer"
    private var currentOrientation: Int = Configuration.ORIENTATION_PORTRAIT
    private var titleText = ""
    private var url: String? = null
    private var sameWithStreamingContent = false
    private var mLocation: PlaybackLocation? = null
    private var mPlaybackState: PlaybackState? = null
    private var mSessionManagerListener: SessionManagerListener<CastSession>? = null
    private var mCastSession: CastSession? = null
    private var mCastContext: CastContext? = null
    private var channelIndex: Int = 0
    private var tvCategoryIndex: Int = 0
    private var isPipMode: Boolean = false
    private var sendingAnalytics: Job? = null

    enum class PlaybackLocation {
        LOCAL, REMOTE
    }

    enum class PlaybackState {
        PLAYING, PAUSED, BUFFERING, IDLE
    }

    @SuppressLint("AppCompatMethod")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player_activity)
        actionBar?.hide()
        val window = window
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        window.statusBarColor = Color.BLACK
        window.navigationBarColor = Color.BLACK

        // IntentFilter yaratish
        intentFilter = IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)

        // NetworkChangeReceiver yaratish
        networkChangeReceiver = object : NetworkChangeReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                super.onReceive(context, intent)
                if (isNetworkAvailable(context!!)) {
                    Log.d(tag, "Reconnect player: Internet bor")
                    rePlayVideo()
                }
            }
        }

        // BroadcastReceiver ni faollashtirish
        registerReceiver(networkChangeReceiver, intentFilter)
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration
        seasonIndex = playerConfiguration.seasonIndex
        episodeIndex = playerConfiguration.episodeIndex
        channelIndex = playerConfiguration.selectChannelIndex
        tvCategoryIndex = playerConfiguration.selectTvCategoryIndex
        currentQuality =
            if (playerConfiguration.initialResolution.isNotEmpty()) playerConfiguration.initialResolution.keys.first() else ""
        titleText = playerConfiguration.title
        url = playerConfiguration.initialResolution.values.first().ifEmpty { "" }

        initializeViews()
        mPlaybackState = PlaybackState.PLAYING
        mCastContext = CastContext.getSharedInstance(this)
        mCastSession = mCastContext?.sessionManager?.currentCastSession
        setupCastListener()
        val remoteMediaClient = mCastSession?.remoteMediaClient
        mLocation =
            if ((remoteMediaClient?.isPlaying == true) || (remoteMediaClient?.isPaused == true) || (remoteMediaClient?.isBuffering == true)) {
                PlaybackLocation.REMOTE
            } else {
                PlaybackLocation.LOCAL
            }
        Log.d(tag, "onCreate: ${remoteMediaClient?.mediaInfo?.contentUrl}")
        if (mLocation == PlaybackLocation.REMOTE) {
            playerConfiguration.resolutions.values.forEach {
                Log.d(tag, "onCreate: $it")
                if (it == remoteMediaClient?.mediaInfo?.contentUrl) {
                    url = it
                    sameWithStreamingContent = true
                }
            }
        }

        retrofitService =
            if (playerConfiguration.baseUrl.isNotEmpty()) Common.retrofitService(playerConfiguration.baseUrl) else null
        initializeClickListeners()

        sWidth = Resources.getSystem().displayMetrics.widthPixels
        gestureDetector = GestureDetector(this, this)
        scaleGestureDetector = ScaleGestureDetector(this, this)
        brightnessSeekbar?.max = 30
        brightnessSeekbar?.progress = 15
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        setAudioFocus()
        maxVolume = audioManager!!.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toDouble()
        volume = audioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC).toDouble()
        volumeSeekBar?.max = maxVolume.toInt()
        maxVolume += 1.0
        volumeSeekBar?.progress = volume.toInt()
        playVideo()
    }

    fun isNetworkAvailable(context: Context?): Boolean {
        if (context == null) return false
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                when {
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> {
                        return true
                    }

                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> {
                        return true
                    }

                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> {
                        return true
                    }
                }
            }
        } else {
            val activeNetworkInfo = connectivityManager.activeNetworkInfo
            if (activeNetworkInfo != null && activeNetworkInfo.isConnected) {
                return true
            }
        }
        return false
    }

    private fun setupCastListener() {
        mSessionManagerListener = object : SessionManagerListener<CastSession> {
            override fun onSessionEnded(session: CastSession, error: Int) {
                onApplicationDisconnected()
            }

            override fun onSessionResumed(session: CastSession, wasSuspended: Boolean) {
                onApplicationConnected(session)
            }

            override fun onSessionResumeFailed(session: CastSession, error: Int) {
                onApplicationDisconnected()
            }

            override fun onSessionStarted(session: CastSession, sessionId: String) {
                onApplicationConnected(session)
            }

            override fun onSessionStartFailed(session: CastSession, error: Int) {
                onApplicationDisconnected()
            }

            override fun onSessionStarting(session: CastSession) {}
            override fun onSessionEnding(session: CastSession) {}
            override fun onSessionResuming(session: CastSession, sessionId: String) {}
            override fun onSessionSuspended(session: CastSession, reason: Int) {}
            private fun onApplicationConnected(castSession: CastSession) {
                Log.d(tag, "onApplicationConnected: $mPlaybackState")
                mCastSession = castSession
                mLocation = PlaybackLocation.REMOTE
                player?.pause()
                performViewsOnConnect()
                loadRemoteMedia(player?.currentPosition ?: 0)
                registerCallBack()
                listenToProgress()
            }

            private fun onApplicationDisconnected() {
                Log.d(tag, "onApplicationDisconnected: $mPlaybackState")
                mPlaybackState = PlaybackState.IDLE
                mLocation = PlaybackLocation.LOCAL
                performViewsOnDisconnect()
                player?.seekTo((customSeekBar!!.progress * 1000).toLong())
                player?.play()
            }
        }
    }

    private fun performViewsOnConnect() {
        pip?.visibility = View.GONE
        videoPosition?.visibility = View.VISIBLE
        exoPosition?.visibility = View.GONE
        exoProgress?.visibility = View.GONE
        customSeekBar?.visibility = View.VISIBLE
        customSeekBar?.isEnabled = true
        Log.d(tag, "performViewsOnConnect: ${(player!!.duration / 1000).toInt()}")
        customSeekBar?.max = if (player?.duration != null) (player!!.duration / 1000).toInt() else 0
        customSeekBar?.progress =
            if (player?.currentPosition != null) (player!!.currentPosition / 1000).toInt() else 0
        customSeekBar?.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(p0: SeekBar?, p1: Int, p2: Boolean) {}

            override fun onStartTrackingTouch(seekBar: SeekBar?) {}

            override fun onStopTrackingTouch(seekBar: SeekBar?) {
                if (mLocation == PlaybackLocation.REMOTE) {
                    val seekOptions: MediaSeekOptions = MediaSeekOptions.Builder()
                        .setPosition((seekBar?.progress)!!.toLong() * 1000).build()
                    mCastSession!!.remoteMediaClient?.seek(seekOptions)
                }
            }
        })
        playPause?.setImageResource(R.drawable.ic_pause)
    }

    private fun performViewsOnDisconnect() {
        pip?.visibility = View.VISIBLE
        videoPosition?.visibility = View.GONE
        exoPosition?.visibility = View.VISIBLE
        exoProgress?.visibility = View.VISIBLE
        customSeekBar?.visibility = View.GONE
        customSeekBar?.isEnabled = false
    }

    private fun loadRemoteMedia(position: Long) {
        if (mCastSession == null) {
            return
        }
        val remoteMediaClient = mCastSession!!.remoteMediaClient ?: return
        remoteMediaClient.load(
            MediaLoadRequestData.Builder().setMediaInfo(buildMediaInfo(position, url))
                .setAutoplay(true).setCurrentTime(position).setCredentials("user-credentials")
                .setAtvCredentials("atv-user-credentials").build()
        )
    }

    private var callback: RemoteMediaClient.Callback? = null
    private fun registerCallBack() {
        val remoteMediaClient = mCastSession!!.remoteMediaClient ?: return
        remoteMediaClient.registerCallback(object : RemoteMediaClient.Callback() {
            override fun onStatusUpdated() {
                if (!remoteMediaClient.isPlaying) {
                    playPause?.setImageResource(R.drawable.ic_play)
                } else {
                    playPause?.setImageResource(R.drawable.ic_pause)
                }
                callback = this
            }
        })
    }

    private fun unregisterCallBack() {
        val remoteMediaClient = mCastSession?.remoteMediaClient ?: return
        if (callback != null) remoteMediaClient.unregisterCallback(callback!!)
    }

    private var listener: RemoteMediaClient.ProgressListener? = null
    private fun listenToProgress() {
        val remoteMediaClient = mCastSession!!.remoteMediaClient ?: return
        remoteMediaClient.addProgressListener(object : RemoteMediaClient.ProgressListener {
            override fun onProgressUpdated(current: Long, max: Long) {
                Log.d(tag, "loadRemoteMedia: $max -> $current")
                customSeekBar?.progress = (current / 1000).toInt()
                videoPosition?.text = MyHelper().formatDuration(current / 1000)
                listener = this
            }
        }, 1500)
    }

    private fun removeProgressListener() {
        val remoteMediaClient = mCastSession?.remoteMediaClient ?: return
        if (listener != null) remoteMediaClient.removeProgressListener(listener!!)
    }

    private fun buildMediaInfo(position: Long, url: String?): MediaInfo {
        val movieMetadata = MediaMetadata(MediaMetadata.MEDIA_TYPE_MOVIE)
        movieMetadata.putString(MediaMetadata.KEY_TITLE, titleText)
        return MediaInfo.Builder(url ?: "").setStreamType(MediaInfo.STREAM_TYPE_BUFFERED)
            .setContentType("videos/m3u8").setMetadata(movieMetadata).setStreamDuration(position)
            .build()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        sendingAnalytics?.cancel()
        closeToRequestAuth?.cancel()
        var seconds = 0L
        if (player?.currentPosition != null) {
            seconds = player?.currentPosition!! / 1000
        }
        removeProgressListener()
        unregisterCallBack()
        val intent = Intent()
        intent.putExtra("position", seconds)
        setResult(PLAYER_ACTIVITY_FINISH, intent)
        finish()
        super.onBackPressed()
    }

    override fun onPause() {
        super.onPause()
        val isPlaying = player?.isPlaying ?: false
        player?.playWhenReady = false
        if (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                isInPictureInPictureMode
            } else {
                false
            }
        ) {
            player?.playWhenReady = isPlaying
            dismissAllBottomSheets()
        }
        mCastContext!!.sessionManager.removeSessionManagerListener(
            mSessionManagerListener!!, CastSession::class.java
        )
    }

    override fun onResume() {
        setAudioFocus()
        if (mLocation == PlaybackLocation.LOCAL) player?.playWhenReady = true
        if (brightness != 0.0) setScreenBrightness(brightness.toInt())
        mCastContext!!.sessionManager.addSessionManagerListener(
            mSessionManagerListener!!, CastSession::class.java
        )
        mLocation = if (mCastSession != null && mCastSession!!.isConnected) {
            PlaybackLocation.REMOTE
        } else {
            PlaybackLocation.LOCAL
        }
        super.onResume()
    }

    override fun onRestart() {
        super.onRestart()
        if (mLocation == PlaybackLocation.LOCAL) player?.playWhenReady = true
    }

    override fun onStop() {
        sendingAnalytics?.cancel()
        closeToRequestAuth?.cancel()
        super.onStop()
        if (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                isInPictureInPictureMode
            } else {
                false
            }
        ) {
            removeProgressListener()
            unregisterCallBack()
            player?.release()
            finish()
        }
    }

    private var lastClicked1: Long = -1L


    @OptIn(DelicateCoroutinesApi::class)
    private fun startSendingAnalytics() {
        if (!playerConfiguration.isLive) sendingAnalytics = GlobalScope.launch {
            while (true) {
                sendAnalytics()
                delay(10000)
            }
        }
    }

    private var closeToRequestAuth: Timer? = null

    private fun wait3MinsAndClose() {
        if (playerConfiguration.isLive && playerConfiguration.authorization.isEmpty()) {
            closeToRequestAuth = Timer()
            closeToRequestAuth?.schedule(timerTask {
                Log.i("wait3mins", "should request auto = true")
                removeProgressListener()
                unregisterCallBack()
                val intent = Intent()
                intent.putExtra("position", -1L)
                setResult(PLAYER_ACTIVITY_FINISH, intent)
                finish()
            }, 15000)
        }
    }


    private fun playVideo() {

        val dataSourceFactory: DataSource.Factory =
            if (!playerConfiguration.fromCache) DefaultHttpDataSource.Factory()
            else DownloadUtil.getDataSourceFactory(this)
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(url)))

        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = playerConfiguration.showController
        player?.setMediaSource(hlsMediaSource)
        player?.seekTo(playerConfiguration.lastPosition * 1000)
        player?.prepare()

        playerView?.findViewById<PlayerControlView>(androidx.media3.ui.R.id.exo_play)
            ?.addVisibilityListener { visibility ->
                val params = nextButtonHeight?.layoutParams
                // Handle visibility change here
                if (visibility == View.VISIBLE) {
                    params?.height = dpToPx(100)
                } else {
                    params?.height = dpToPx(50)
                }
                nextButtonHeight?.layoutParams = params
            }

        startSendingAnalytics()
        wait3MinsAndClose()


        player?.addListener(object : Player.Listener {
            override fun onEvents(
                player: Player, events: Player.Events
            ) {
                if (playerConfiguration.isSerial && !isLastEpisode() && !isPipMode) {
                    val current = player.currentPosition
                    val max = player.contentDuration
                    val showPlayNextTime = if (max < 18000) 10000L else (max * 0.05).toLong()
                    if (current > max - showPlayNextTime) {
                        nextButton?.visibility = View.VISIBLE
                    } else {
                        nextButton?.visibility = View.GONE
                    }
                } else if (nextButton?.visibility == View.VISIBLE) {
                    nextButton?.visibility = View.GONE
                }
            }

            override fun onPlayerError(error: PlaybackException) {
                Log.d(tag, "onPlayerError: ${error.errorCode}")
                player?.pause()
            }

            override fun onIsPlayingChanged(isPlaying: Boolean) {
                if (mLocation == PlaybackLocation.REMOTE) return
                if (isPlaying) {
                    mPlaybackState = PlaybackState.PLAYING
                    playPause?.setImageResource(R.drawable.ic_pause)
                } else {
                    mPlaybackState = PlaybackState.PAUSED
                    playPause?.setImageResource(R.drawable.ic_play)
                }
            }

            override fun onPlaybackStateChanged(playbackState: Int) {
                when (playbackState) {
                    Player.STATE_BUFFERING -> {
                        mPlaybackState = PlaybackState.BUFFERING
                        playPause?.visibility = View.GONE
                        progressbar?.visibility = View.VISIBLE
                        if (playerView?.isControllerFullyVisible == false) {
                            playerView?.setShowBuffering(SHOW_BUFFERING_ALWAYS)
                        }
                    }

                    Player.STATE_READY -> {
                        if (mLocation == PlaybackLocation.REMOTE && customSeekBar?.visibility == View.GONE) {
                            performViewsOnConnect()
                        }
                        playPause?.visibility = View.VISIBLE
                        progressbar?.visibility = View.GONE
                        if (playerView?.isControllerFullyVisible == false) {
                            playerView?.setShowBuffering(SHOW_BUFFERING_NEVER)
                        }
                    }

                    Player.STATE_ENDED -> {
                        if (!isPipMode) playPause?.setImageResource(R.drawable.ic_play)
                        if (playerConfiguration.isSerial) {
                            if (isLastEpisode()) {
                                onBackPressed()
                            } else {
                                nextButton?.performClick()
                            }
                        } else if (!playerConfiguration.isLive) {
                            onBackPressed()
                        }
                    }

                    Player.STATE_IDLE -> {
                        mPlaybackState = PlaybackState.IDLE
                    }
                }
            }
        })
        if (mLocation == PlaybackLocation.LOCAL) {
            player?.playWhenReady = true
        } else {
            if (!sameWithStreamingContent) {
                loadRemoteMedia(playerConfiguration.lastPosition)
            }
            registerCallBack()
            listenToProgress()
        }
    }

    private fun rePlayVideo() {
        player?.prepare()
        player?.play()
    }


    @SuppressLint("ClickableViewAccessibility")
    private fun initializeViews() {
        shareMovieLinkIv = findViewById(R.id.iv_share_movie)
        playerView = findViewById(R.id.exo_player_view)
        customPlayback = findViewById(R.id.custom_playback)
        layoutBrightness = findViewById(R.id.layout_brightness)
        brightnessSeekbar = findViewById(R.id.brightness_seek)
        brightnessSeekbar?.isEnabled = false
        layoutVolume = findViewById(R.id.layout_volume)
        volumeSeekBar = findViewById(R.id.volume_seek)
        volumeSeekBar?.isEnabled = false
        close = findViewById(R.id.video_close)
        pip = findViewById(R.id.video_pip)
        cast = findViewById(R.id.video_cast)
        tvChannels = findViewById(R.id.tv_channels)
        if (playerConfiguration.isLive) {
            tvChannelsButton?.visibility = View.VISIBLE
        }
        CastButtonFactory.setUpMediaRouteButton(applicationContext, cast!!)
        more = findViewById(R.id.video_more)
        title = findViewById(R.id.video_title)
        title1 = findViewById(R.id.video_title1)
        title?.text = titleText
        title1?.text = titleText

        rewind = findViewById(R.id.video_rewind)
        forward = findViewById(R.id.video_forward)
        playPause = findViewById(R.id.video_play_pause)
        progressbar = findViewById(R.id.video_progress_bar)
        timer = findViewById(R.id.timer)
        if (playerConfiguration.isLive) {
            timer?.visibility = View.GONE
        }
        videoPosition = findViewById(R.id.video_position)
        exoPosition = findViewById(R.id.exo_position)
        live = findViewById(R.id.live)
        if (playerConfiguration.isLive) {
            shareMovieLinkIv?.visibility = View.GONE
            live?.visibility = View.VISIBLE
        }
        episodesButton = findViewById(R.id.button_episodes)
        episodesText = findViewById(R.id.text_episodes)
        if (playerConfiguration.seasons.isNotEmpty()) {
            episodesButton?.visibility = View.VISIBLE
            episodesText?.text = playerConfiguration.episodeButtonText
        }
        nextButton = findViewById(R.id.button_next)
        nextButtonHeight = findViewById(R.id.button_next_height)
        nextButtonHeight?.layoutParams?.height = dpToPx(100)
        nextText = findViewById(R.id.text_next)
        nextText?.text = playerConfiguration.nextButtonText


//        if (playerConfiguration.seasons.isNotEmpty())
//            if (playerConfiguration.isSerial && !(seasonIndex == playerConfiguration.seasons.size - 1 && episodeIndex == playerConfiguration.seasons[seasonIndex].movies.size - 1)) {
//                nextButton?.visibility = View.VISIBLE
//                nextText?.text = playerConfiguration.nextButtonText
//            } else {
//                nextButton?.visibility = View.GONE
//                nextText?.visibility = View.GONE
//            }
        tvProgramsButton = findViewById(R.id.button_tv_programs)
        if (playerConfiguration.isLive) {
            tvProgramsButton?.visibility = View.VISIBLE
            tvChannels?.visibility = View.VISIBLE
        }
        zoom = findViewById(R.id.zoom)
        orientation = findViewById(R.id.orientation)
        subtitleButton = findViewById(R.id.subtitle_button)
        subtitleButton?.visibility = View.VISIBLE

        exoProgress = findViewById(R.id.exo_progress)
        customSeekBar = findViewById(R.id.progress_bar)
        customSeekBar?.isEnabled = false
        if (playerConfiguration.isLive) {
            exoProgress?.visibility = View.GONE
            rewind?.visibility = View.GONE
            forward?.visibility = View.GONE
            customSeekBar?.visibility = View.VISIBLE
        }
        findViewById<PlayerView>(R.id.exo_player_view).setOnTouchListener { _, motionEvent ->
            if (motionEvent.pointerCount == 2) {
                scaleGestureDetector?.onTouchEvent(motionEvent)
            } else if (playerView?.isControllerFullyVisible == false && motionEvent.pointerCount == 1) {
                gestureDetector?.onTouchEvent(motionEvent)
                if (motionEvent.action == MotionEvent.ACTION_UP) {
                    layoutBrightness?.visibility = View.GONE
                    layoutVolume?.visibility = View.GONE
                }
            }
            return@setOnTouchListener true
        }
    }


    @SuppressLint("SetTextI18n", "ClickableViewAccessibility")
    private fun initializeClickListeners() {
        customPlayback?.setOnTouchListener { _, motionEvent ->
            if (motionEvent.pointerCount == 1 && motionEvent.action == MotionEvent.ACTION_UP) {
                lastClicked1 = if (lastClicked1 == -1L) {
                    System.currentTimeMillis()
                } else {
                    if (isDoubleClicked(lastClicked1)) {
                        if (motionEvent!!.x < sWidth / 2) {
                            player?.seekTo(player!!.currentPosition - 10000)
                        } else {
                            player?.seekTo(player!!.currentPosition + 10000)
                        }
                    } else {
                        playerView?.hideController()
                    }
                    -1L
                }
                Handler(Looper.getMainLooper()).postDelayed({
                    if (lastClicked1 != -1L) {
                        playerView?.hideController()
                        lastClicked1 = -1L
                    }
                }, 300)
            }
            return@setOnTouchListener true
        }

        shareMovieLinkIv?.setOnClickListener {
            shareMovieLink()
        }

        close?.setOnClickListener {
            closeToRequestAuth?.cancel()
            sendingAnalytics?.cancel()
            if (player?.isPlaying == true) {
                player?.stop()
            }
            var seconds = 0L
            if (player?.currentPosition != null) {
                seconds = player?.currentPosition!! / 1000
            }
            removeProgressListener()
            unregisterCallBack()
            val intent = Intent()
            intent.putExtra("position", seconds)
            setResult(PLAYER_ACTIVITY_FINISH, intent)
            finish()
        }
        pip?.setOnClickListener {
            if (mLocation == PlaybackLocation.REMOTE) {
                return@setOnClickListener
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val params = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    PictureInPictureParams.Builder().setAspectRatio(Rational(16, 9))
                        .setAutoEnterEnabled(false).build()
                } else {
                    PictureInPictureParams.Builder().setAspectRatio(Rational(16, 9)).build()
                }
                enterPictureInPictureMode(params)
            } else {
                Toast.makeText(this, "This is my Toast message!", Toast.LENGTH_SHORT).show()
            }
        }
        more?.setOnClickListener {
            showSettingsBottomSheet()
        }
        rewind?.setOnClickListener {
            if (mLocation == PlaybackLocation.LOCAL) {
                if (player != null) player?.seekTo(player!!.currentPosition - 10000)
            } else {
                val remoteMediaClient = mCastSession!!.remoteMediaClient
                val seekOptions: MediaSeekOptions = MediaSeekOptions.Builder()
                    .setPosition((customSeekBar!!.progress * 1000 - 10000).toLong()).build()
                remoteMediaClient?.seek(seekOptions)
            }
        }
        forward?.setOnClickListener {
            if (mLocation == PlaybackLocation.LOCAL) {
                if (player != null) player?.seekTo(player!!.currentPosition + 10000)
            } else {
                val remoteMediaClient = mCastSession!!.remoteMediaClient
                val seekOptions: MediaSeekOptions = MediaSeekOptions.Builder()
                    .setPosition((customSeekBar!!.progress * 1000 + 10000).toLong()).build()
                remoteMediaClient?.seek(seekOptions)
            }
        }
        playPause?.setOnClickListener {
            if (mLocation == PlaybackLocation.LOCAL) {
                if (player?.isPlaying == true) {
                    player?.pause()
                } else {
                    player?.play()
                }
            } else {
                val remoteMediaClient = mCastSession!!.remoteMediaClient
                if (remoteMediaClient?.isPlaying == true) {
                    remoteMediaClient.pause()

                } else {
                    remoteMediaClient?.play()
                }
            }
        }
        tvChannels?.setOnClickListener {
            showChannelsBottomSheet()
        }
        episodesButton?.setOnClickListener {
            if (playerConfiguration.seasons.isNotEmpty()) showEpisodesBottomSheet()
        }

        nextButton?.setOnClickListener {
            if (playerConfiguration.seasons.isEmpty() || isLastEpisode()) {
                return@setOnClickListener
            }
            if (seasonIndex < playerConfiguration.seasons.size) {
                if (episodeIndex < playerConfiguration.seasons[seasonIndex].movies.size - 1) {
                    episodeIndex++
                } else {
                    seasonIndex++
                    episodeIndex = 0
                }
            }

            if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
                titleText =
                    "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.title.removeSeasonEpisode()
                title?.text = titleText
                title1?.text = title?.text
                title1?.visibility = View.VISIBLE
                title?.text = ""
                title?.visibility = View.INVISIBLE
            } else {
                titleText =
                    "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.title.removeSeasonEpisode()
                title?.text = titleText
                title?.visibility = View.VISIBLE
                title1?.text = ""
                title1?.visibility = View.GONE
            }
            if (playerConfiguration.isMegogo && playerConfiguration.isSerial) {
                getMegogoStream()
            } else if (playerConfiguration.isPremier && playerConfiguration.isSerial) {
                getPremierStream()
            } else if (playerConfiguration.isMoreTv && playerConfiguration.isSerial) {
                getMoreTvStream()
            } else {
                url =
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[playerConfiguration.autoText]
                val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                    .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                player?.setMediaSource(hlsMediaSource)
                player?.prepare()
                val newColor = ContextCompat.getColor(this, R.color.white)
                subtitleButton?.setColorFilter(newColor)
                if (mLocation == PlaybackLocation.LOCAL) {
                    player?.playWhenReady
                } else {
                    loadRemoteMedia(0)
                }
            }
            if (isPipMode) playerView?.hideController()
//            nextButton?.visibility = View.GONE
        }

        tvProgramsButton?.setOnClickListener {
            if (playerConfiguration.programsInfoList.isNotEmpty()) showTvProgramsBottomSheet()
        }

        zoom?.setOnClickListener {
            if (mLocation == PlaybackLocation.REMOTE) {
                return@setOnClickListener
            }
            when (playerView?.resizeMode) {
                AspectRatioFrameLayout.RESIZE_MODE_ZOOM -> {
                    zoom?.setImageResource(R.drawable.ic_fit)
                    playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
                }

                AspectRatioFrameLayout.RESIZE_MODE_FILL -> {
                    zoom?.setImageResource(R.drawable.ic_crop_fit)
                    playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
                }

                AspectRatioFrameLayout.RESIZE_MODE_FIT -> {
                    zoom?.setImageResource(R.drawable.ic_stretch)
                    playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
                }

                AspectRatioFrameLayout.RESIZE_MODE_FIXED_HEIGHT -> {}
                AspectRatioFrameLayout.RESIZE_MODE_FIXED_WIDTH -> {}
            }
        }
        orientation?.setOnClickListener {
            requestedOrientation =
                if (resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                    ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                } else {
                    if (playerConfiguration.isLive) {
                        playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
                    }
                    ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                }
            it.postDelayed({
                requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
            }, 3000)
        }

        subtitleButton?.setOnClickListener {
            if (currentSubtitle.isNullOrEmpty()) {
                Log.d("", "subtitle: show initial")
                player?.let {
                    val subtitles = it.getAvailableSubtitles()
                    if (subtitles.isNotEmpty()) {
                        it.changeSubtitle(subtitles.first())
                        currentSubtitle = subtitles.first()
                        val newColor = ContextCompat.getColor(this, R.color.blue)
                        subtitleButton?.setColorFilter(newColor)
                    }
                }
            } else {
                Log.d("", "subtitle: hide")
                player?.hideSubtitle()
                currentSubtitle = null
                val newColor = ContextCompat.getColor(this, R.color.white)
                subtitleButton?.setColorFilter(newColor)
            }
        }
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (mLocation == PlaybackLocation.REMOTE) {
            return
        }
        val params = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PictureInPictureParams.Builder().setAspectRatio(Rational(100, 50))
                .setAutoEnterEnabled(false).build()
        } else {
            PictureInPictureParams.Builder().setAspectRatio(Rational(100, 50)).build()
        }
        enterPictureInPictureMode(params)
    }

    private fun shareMovieLink() {
        val url = playerConfiguration.movieShareLink
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "text/html"
        intent.putExtra(Intent.EXTRA_TEXT, url)
        val chooser = Intent.createChooser(intent, "Share using...")
        startActivity(chooser)
    }


    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean, newConfig: Configuration
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
            if (isInPictureInPictureMode) {
                isPipMode = true
                playerView?.hideController()
                nextButton?.visibility = View.GONE
                playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
            } else {
                isPipMode = false
                playerView?.showController()
                playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
            }
        }
    }

    private fun sendAnalytics() {
        val request = AnalyticsRequest(
            genre = "",
            movie_key = playerConfiguration.videoId,
            profile_id = playerConfiguration.profileId,
            season_key = if (playerConfiguration.isSerial) "${seasonIndex + 1}" else "0",
            episode_key = if (playerConfiguration.isSerial) "${episodeIndex + 1}" else "0",
            title = playerConfiguration.title.removeSeasonEpisode(),
            user_id = playerConfiguration.userId,
            video_platform = if (playerConfiguration.isMegogo) "MEGOGO"
            else if (playerConfiguration.isPremier) "PREMIER"
            else if (playerConfiguration.isMoreTv) "MORETV" else "UZD+"
        )
        Log.i("SEND ANALYTICS", "request: $request")
        retrofitService?.sendAnalytics(
            playerConfiguration.authorization,
            playerConfiguration.sessionId,
            body = request,
        )?.enqueue(object : Callback<Any> {
            override fun onResponse(
                call: Call<Any>, response: Response<Any>
            ) {
                Log.i("SEND ANALYTICS", "response: ${response.body()}")
            }

            override fun onFailure(call: Call<Any>, t: Throwable) {
                Log.i("SEND ANALYTICS", "error: $t")
                t.printStackTrace()
            }
        })
    }

    private fun getMegogoStream() {
        retrofitService?.getMegogoStream(
            playerConfiguration.authorization,
            playerConfiguration.sessionId,
            playerConfiguration.seasons[seasonIndex].movies[episodeIndex].id,
            playerConfiguration.megogoAccessToken
        )?.enqueue(object : Callback<MegogoStreamResponse> {
            override fun onResponse(
                call: Call<MegogoStreamResponse>, response: Response<MegogoStreamResponse>
            ) {
                val body = response.body()
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    map[playerConfiguration.autoText] = body.data!!.src!!
                    body.data.bitrates?.forEach {
                        map["${it!!.bitrate}p"] = it.src!!
                    }
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions = map
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
                    player?.setMediaSource(hlsMediaSource)
                    player?.prepare()
                    player?.playWhenReady
                }
            }

            override fun onFailure(call: Call<MegogoStreamResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    private fun getMoreTvStream() {
        retrofitService?.getMoreTvStream(
            playerConfiguration.authorization,
            playerConfiguration.sessionId,
            playerConfiguration.seasons[seasonIndex].movies[episodeIndex].id,
        )?.enqueue(object : Callback<MoreTvStreamResponse> {
            override fun onResponse(
                call: Call<MoreTvStreamResponse>, response: Response<MoreTvStreamResponse>
            ) {
                val body = response.body()
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    map["moretv"] = body.data.url
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions = map
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions["moretv"])))
                    player?.setMediaSource(hlsMediaSource)
                    player?.prepare()
                    player?.playWhenReady
                }
            }

            override fun onFailure(call: Call<MoreTvStreamResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    private fun getPremierStream() {
        retrofitService?.getPremierStream(
            playerConfiguration.authorization,
            playerConfiguration.sessionId,
            playerConfiguration.videoId,
            playerConfiguration.seasons[seasonIndex].movies[episodeIndex].id,
        )?.enqueue(object : Callback<PremierStreamResponse> {
            override fun onResponse(
                call: Call<PremierStreamResponse>, response: Response<PremierStreamResponse>
            ) {
                val body = response.body()
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    body.file_info?.forEach {
                        if (it!!.quality == "auto") {
                            map[playerConfiguration.autoText] = it.file_name!!
                        } else {
                            map[it.quality!!] = it.file_name!!
                        }
                    }
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions = map
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
                    player?.setMediaSource(hlsMediaSource)
                    player?.prepare()
                    player?.playWhenReady
                }
            }

            override fun onFailure(call: Call<PremierStreamResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    private fun getSingleTvChannel(tvCIndex: Int, cIndex: Int) {
        tvCategoryIndex = tvCIndex
        channelIndex = cIndex
        retrofitService?.getSingleTvChannel(
            playerConfiguration.authorization,
            playerConfiguration.tvCategories[tvCIndex].channels[cIndex].id,
            playerConfiguration.ip,
        )?.enqueue(object : Callback<TvChannelResponse> {
            override fun onResponse(
                call: Call<TvChannelResponse>, response: Response<TvChannelResponse>
            ) {
                val body = response.body()
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    map["Auto"] = body.channelStreamAll
                    playerConfiguration.resolutions = map

                    url = body.channelStreamAll
                    title?.text = playerConfiguration.tvCategories[tvCIndex].channels[cIndex].name
                    title1?.text = playerConfiguration.tvCategories[tvCIndex].channels[cIndex].name
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                    player?.setMediaSource(hlsMediaSource)
                    player?.prepare()
                    player?.playWhenReady
                }
            }

            override fun onFailure(call: Call<TvChannelResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    private fun dpToPx(dp: Int): Int {
        val scale = resources.displayMetrics.density
        return (dp * scale + 0.5f).toInt()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        currentOrientation = newConfig.orientation
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            setFullScreen()
            if (playerConfiguration.isLive) {
                playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            }
            title?.text = title1?.text
            title?.visibility = View.VISIBLE
            title1?.text = ""
            title1?.visibility = View.GONE
//            if (playerConfiguration.isSerial)
//                if (isLastEpisode())
//                    nextButton?.visibility = View.GONE
//                else
//                    nextButton?.visibility = View.VISIBLE
//            else
//                nextButton?.visibility = View.GONE
            zoom?.visibility = View.VISIBLE
            orientation?.setImageResource(R.drawable.ic_portrait)
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
                    backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
                }

                BottomSheet.SETTINGS -> {
                    backButtonSettingsBottomSheet?.visibility = View.VISIBLE
                }

                BottomSheet.TV_PROGRAMS -> {}
                BottomSheet.QUALITY_OR_SPEED -> backButtonQualitySpeedBottomSheet?.visibility =
                    View.VISIBLE

                BottomSheet.CHANNELS -> {}
                BottomSheet.NONE -> {}
            }
        } else {
            cutFullScreen()
            title1?.text = title?.text
            title1?.visibility = View.VISIBLE
            title?.text = ""
            title?.visibility = View.INVISIBLE
//            if (playerConfiguration.isSerial)
//                if (isLastEpisode())
//                    nextButton?.visibility = View.GONE
//                else
//                    nextButton?.visibility = View.VISIBLE
//            else
//                nextButton?.visibility = View.GONE
            zoom?.visibility = View.GONE
            orientation?.setImageResource(R.drawable.ic_landscape)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
                    backButtonEpisodeBottomSheet?.visibility = View.GONE
                }

                BottomSheet.SETTINGS -> {
                    backButtonSettingsBottomSheet?.visibility = View.GONE
                }

                BottomSheet.TV_PROGRAMS -> {}
                BottomSheet.QUALITY_OR_SPEED -> backButtonSettingsBottomSheet?.visibility =
                    View.GONE

                BottomSheet.CHANNELS -> {}
                BottomSheet.NONE -> {}
            }
        }
    }

    private fun setFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        WindowInsetsControllerCompat(window, findViewById(R.id.player_activity)).let { controller ->
            controller.hide(WindowInsetsCompat.Type.systemBars())
            controller.systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }
    }

    private fun cutFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, true)
        WindowInsetsControllerCompat(window, findViewById(R.id.player_activity)).show(
            WindowInsetsCompat.Type.systemBars()
        )
    }

    private var currentBottomSheet = BottomSheet.NONE

    private fun isLastEpisode(): Boolean {
        return playerConfiguration.seasons.size == seasonIndex + 1 && playerConfiguration.seasons[playerConfiguration.seasons.size - 1].movies.size == episodeIndex + 1
    }

    private fun showTvProgramsBottomSheet() {
        currentBottomSheet = BottomSheet.TV_PROGRAMS
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.behavior.peekHeight = Resources.getSystem().displayMetrics.heightPixels
        bottomSheetDialog.setContentView(R.layout.tv_programs_sheet)
        val backButtonBottomSheet =
            bottomSheetDialog.findViewById<ImageView>(R.id.tv_program_sheet_back)
        backButtonBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val titleBottomSheet = bottomSheetDialog.findViewById<TextView>(R.id.tv_program_sheet_title)
        titleBottomSheet?.text = title?.text
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.tv_programs_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.tv_programs_view_pager)
        viewPager?.adapter = TvProgramsPagerAdapter(this, playerConfiguration.programsInfoList)
        viewPager?.currentItem = 1
        TabLayoutMediator(tabLayout!!, viewPager!!) { tab, position ->
            tab.text = playerConfiguration.programsInfoList[position].day
        }.attach()
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private var backButtonEpisodeBottomSheet: ImageView? = null
    private fun showEpisodesBottomSheet() {
        currentBottomSheet = BottomSheet.EPISODES
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.episodes)
        backButtonEpisodeBottomSheet = bottomSheetDialog.findViewById(R.id.episode_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonEpisodeBottomSheet?.visibility = View.GONE
        } else {
            backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
        }
        backButtonEpisodeBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val titleBottomSheet = bottomSheetDialog.findViewById<TextView>(R.id.episodes_sheet_title)
        titleBottomSheet?.text = title?.text
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.episode_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.episode_view_pager)
        viewPager?.adapter = EpisodePagerAdapter(viewPager!!,
            this,
            playerConfiguration.seasons,
            seasonIndex,
            episodeIndex,
            object : EpisodePagerAdapter.OnClickListener {
                @SuppressLint("SetTextI18n")
                override fun onClick(epIndex: Int, seasIndex: Int) {
                    seasonIndex = seasIndex
                    episodeIndex = epIndex
                    if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
                        titleText =
                            "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.title.removeSeasonEpisode()
                        title?.text = titleText
                        title1?.text = title?.text
                        title1?.visibility = View.VISIBLE
                        title?.text = ""
                        title?.visibility = View.INVISIBLE
                    } else {
                        titleText =
                            "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.title.removeSeasonEpisode()
                        title?.text = titleText
                        title?.visibility = View.VISIBLE
                        title1?.text = ""
                        title1?.visibility = View.GONE
                    }
                    if (playerConfiguration.isMegogo && playerConfiguration.isSerial) {
                        getMegogoStream()
                    } else if (playerConfiguration.isPremier && playerConfiguration.isSerial) {
                        getPremierStream()
                    } else if (playerConfiguration.isMoreTv && playerConfiguration.isSerial) {
                        getMoreTvStream()
                    } else {
                        url =
                            playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[playerConfiguration.autoText]
                        currentQuality = playerConfiguration.autoText
                        qualityTextValue?.text = playerConfiguration.autoText
                        currentSubtitle = null
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                        player?.setMediaSource(hlsMediaSource)
                        player?.prepare()
                        if (mLocation == PlaybackLocation.LOCAL) {
                            player?.playWhenReady
                        } else {
                            loadRemoteMedia(0)
                        }
                        val newColor = ContextCompat.getColor(baseContext, R.color.white)
                        subtitleButton?.setColorFilter(newColor)
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        TabLayoutMediator(tabLayout!!, viewPager) { tab, position ->
            tab.text = playerConfiguration.seasons[position].title
        }.attach()
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private fun showChannelsBottomSheet() {
        currentBottomSheet = BottomSheet.CHANNELS
        val bottomSheetDialog = BottomSheetDialog(this, R.style.ChannelsBottomSheetDialog)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.behavior.peekHeight = Resources.getSystem().displayMetrics.heightPixels
        bottomSheetDialog.setContentView(R.layout.channels_page)
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.tv_category_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.tv_category_view_pager)
        viewPager?.adapter = TvCategoryPagerAdapter(
            this, playerConfiguration.tvCategories,
            object : TvCategoryPagerAdapter.OnClickListener {
                override fun onClick(tvCIndex: Int, cIndex: Int) {
                    getSingleTvChannel(tvCIndex, cIndex)
                    bottomSheetDialog.dismiss()
                }
            },
        )
        viewPager?.currentItem = tvCategoryIndex
        viewPager?.orientation = ViewPager2.ORIENTATION_HORIZONTAL
        viewPager?.isUserInputEnabled = false

        TabLayoutMediator(tabLayout!!, viewPager!!) { tab, position ->
            tab.text = playerConfiguration.tvCategories[position].title
        }.attach()
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private fun dismissAllBottomSheets() {
        for (bottomSheet in listOfAllOpenedBottomSheets) {
            bottomSheet.dismiss()
        }
        listOfAllOpenedBottomSheets.clear()
    }


    private var speeds =
        mutableListOf("0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x")
    private var currentQuality = ""
    private var currentSpeed = "1.0x"
    private var qualityTextValue: TextView? = null
    private var speedTextValue: TextView? = null
    private var subtitleTextValue: TextView? = null
    private var audioTextValue: TextView? = null

    private var backButtonSettingsBottomSheet: ImageView? = null
    private fun showSettingsBottomSheet() {
        if (isSettingsBottomSheetOpened) {
            return
        }
        currentAudioTrack = player?.audioFormat?.label ?: ""
        if (playerConfiguration.isUzdMovie()) {
            val qualities = player!!.getAvailableQualities(playerConfiguration.autoText)
            if (currentQuality.isAutoQuality(playerConfiguration)) {
                currentQuality = qualities[0]
                qualityTextValue?.text = qualities[0]
            }
        }

        if (playerConfiguration.isMoreTv) {
            val qualities = player!!.getAvailableQualities(playerConfiguration.autoText)
            if (currentQuality == "moretv" && playerConfiguration.isMoreTv) {
                currentQuality = qualities[0]
                qualityTextValue?.text = qualities[0]
            }
        }

        isSettingsBottomSheetOpened = true
        currentBottomSheet = BottomSheet.SETTINGS
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.settings_bottom_sheet)
        backButtonSettingsBottomSheet = bottomSheetDialog.findViewById(R.id.settings_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonSettingsBottomSheet?.visibility = View.GONE
        } else {
            backButtonSettingsBottomSheet?.visibility = View.VISIBLE
        }
        backButtonSettingsBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val quality = bottomSheetDialog.findViewById<LinearLayout>(R.id.quality)
        val speed = bottomSheetDialog.findViewById<LinearLayout>(R.id.speed)
        val subtitle = bottomSheetDialog.findViewById<LinearLayout>(R.id.subtitle)
        val audio = bottomSheetDialog.findViewById<LinearLayout>(R.id.audio)
        bottomSheetDialog.findViewById<TextView>(R.id.quality_settings_text)?.text =
            playerConfiguration.qualityText
        bottomSheetDialog.findViewById<TextView>(R.id.speed_settings_text)?.text =
            playerConfiguration.speedText
        bottomSheetDialog.findViewById<TextView>(R.id.subtitle_settings_text)?.text =
            playerConfiguration.subtitleText
        bottomSheetDialog.findViewById<TextView>(R.id.audio_settings_text)?.text =
            playerConfiguration.audioText
        qualityTextValue = bottomSheetDialog.findViewById(R.id.quality_settings_value_text)
        speedTextValue = bottomSheetDialog.findViewById(R.id.speed_settings_value_text)
        qualityTextValue?.text = currentQuality
        speedTextValue?.text = currentSpeed
        subtitleTextValue = bottomSheetDialog.findViewById(R.id.subtitle_settings_value_text)
        subtitleTextValue?.text = currentSubtitle ?: ""
        audioTextValue = bottomSheetDialog.findViewById(R.id.audio_settings_value_text)
        audioTextValue?.text = currentAudioTrack

        quality?.setOnClickListener {
            if (playerConfiguration.isSerial) {
                if (playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions.isNotEmpty() || playerConfiguration.isMoreTv) showQualitySpeedSheet(
                    currentQuality,
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions.keys.toList() as? ArrayList
                        ?: ArrayList(),
                    true,
                )
            } else {
                showQualitySpeedSheet(
                    currentQuality,
                    playerConfiguration.resolutions.keys.toList() as? ArrayList ?: ArrayList(),
                    true,
                )
            }
        }

        speed?.setOnClickListener {
            if (mLocation == PlaybackLocation.LOCAL) showQualitySpeedSheet(
                currentSpeed, speeds as ArrayList, false
            )
        }

        subtitle?.setOnClickListener {
            showSubtitlesBottomSheet()
        }

        audio?.setOnClickListener {
            showAudioLanguageBottomSheet()
        }

        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            isSettingsBottomSheetOpened = false
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private var currentAudioTrack: String = player?.audioFormat?.label ?: ""
    private var currentSubtitle: String? = null

    private fun showSubtitlesBottomSheet() {
        isQualitySpeedBottomSheetOpened = true
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.quality_speed_sheet)
        bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
            playerConfiguration.subtitleText

        val subtitles = player?.getAvailableSubtitles() ?: emptyList()

        backButtonQualitySpeedBottomSheet =
            bottomSheetDialog.findViewById(R.id.quality_speed_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonQualitySpeedBottomSheet?.visibility = View.GONE
        } else {
            backButtonQualitySpeedBottomSheet?.visibility = View.VISIBLE
        }

        backButtonQualitySpeedBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }


        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView

        val adapter = QualitySpeedAdapter(
            currentSubtitle ?: "",
            this,
            subtitles as ArrayList<String>,
            (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    val subtitle = subtitles[position]
                    Log.d("", "onClickSubtitleSelection: $subtitle")
                    player?.changeSubtitle(subtitle)
                    currentSubtitle = subtitle
                    subtitleTextValue?.text = currentSubtitle
                    subtitleButton?.setColorFilter(
                        ContextCompat.getColor(
                            baseContext, R.color.blue
                        )
                    )
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
            isQualitySpeedBottomSheetOpened = false
        }
    }

    private fun showAudioLanguageBottomSheet() {
        isQualitySpeedBottomSheetOpened = true
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.quality_speed_sheet)
        bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
            playerConfiguration.audioText

        val audioLanguages = player?.getAvailableAudioLanguages() ?: emptyList()

        backButtonQualitySpeedBottomSheet =
            bottomSheetDialog.findViewById(R.id.quality_speed_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonQualitySpeedBottomSheet?.visibility = View.GONE
        } else {
            backButtonQualitySpeedBottomSheet?.visibility = View.VISIBLE
        }
        backButtonQualitySpeedBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }

        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView

        val adapter = QualitySpeedAdapter(
            currentAudioTrack,
            this,
            audioLanguages as ArrayList<String>,
            (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    val audioLang = audioLanguages[position]
                    Log.d("", "onClickTrackSelection: $audioLang")
                    player?.changeAudioLanguage(audioLang)
                    currentAudioTrack = audioLang
                    audioTextValue?.text = currentAudioTrack
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
            isQualitySpeedBottomSheetOpened = false
        }
    }


    private var backButtonQualitySpeedBottomSheet: ImageView? = null
    private fun showQualitySpeedSheet(
        initialValue: String, list: ArrayList<String>, fromQuality: Boolean
    ) {
        if (isQualitySpeedBottomSheetOpened) {
            return
        }
        var finalList: ArrayList<String> = list

        if ((playerConfiguration.isUzdMovie() || playerConfiguration.isMoreTv) && fromQuality) {
            finalList = player!!.getAvailableQualities(playerConfiguration.autoText)
        }

        isQualitySpeedBottomSheetOpened = true
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this)
        listOfAllOpenedBottomSheets.add(bottomSheetDialog)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.quality_speed_sheet)
        backButtonQualitySpeedBottomSheet =
            bottomSheetDialog.findViewById(R.id.quality_speed_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonQualitySpeedBottomSheet?.visibility = View.GONE
        } else {
            backButtonQualitySpeedBottomSheet?.visibility = View.VISIBLE
        }
        backButtonQualitySpeedBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }

        if (fromQuality) {
            bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
                playerConfiguration.qualityText
        } else {
            bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
                playerConfiguration.speedText
        }
        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView
        //sorting
        val formats = mutableListOf<String>()
        if (fromQuality) {
            var auto = ""
            finalList.forEach {
                if (it.substring(0, it.length - 1).toIntOrNull() != null) {
                    formats.add(it)
                } else {
                    auto = it
                }
            }
            for (i in 0 until formats.size) {
                for (j in i until formats.size) {
                    val first = formats[i]
                    val second = formats[j]
                    if (first.substring(0, first.length - 1).toInt() < second.substring(
                            0, second.length - 1
                        ).toInt()
                    ) {
                        val a = formats[i]
                        formats[i] = formats[j]
                        formats[j] = a
                    }
                }
            }
            if (auto.isNotEmpty()) {
                formats.add(0, auto)
            }
        } else {
            formats.addAll(finalList)
        }
        val adapter = QualitySpeedAdapter(
            initialValue,
            this,
            formats as ArrayList<String>,
            (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        if (playerConfiguration.isMoreTv || playerConfiguration.isUzdMovie()) {
                            player!!.changeVideoQuality(index = position, finalList.size, url ?: "")
                            currentQuality = finalList[position]
                            qualityTextValue?.text = currentQuality
                        } else {
                            currentQuality = formats[position]
                            qualityTextValue?.text = currentQuality
                            if (player?.isPlaying == true) {
                                player?.pause()
                            }
                            val currentPosition = player?.currentPosition
                            val dataSourceFactory: DataSource.Factory =
                                DefaultHttpDataSource.Factory()
                            url =
                                (if (playerConfiguration.isSerial) playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality]
                                else playerConfiguration.resolutions[currentQuality])?.toHttps()
                            val hlsMediaSource: HlsMediaSource =
                                HlsMediaSource.Factory(dataSourceFactory)
                                    .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                            player?.setMediaSource(hlsMediaSource)
                            player?.seekTo(currentPosition!!)
                            if (mLocation == PlaybackLocation.LOCAL) {
                                player?.play()
                            } else {
                                if (playerConfiguration.isSerial) {
                                    loadRemoteMedia(currentPosition ?: 0)
                                } else {
                                    loadRemoteMedia(currentPosition ?: 0)
                                }
                            }
                        }
                    } else {
                        if (mLocation == PlaybackLocation.REMOTE) {
                            return
                        }
                        currentSpeed = formats[position]
                        speedTextValue?.text = currentSpeed
                        player?.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
            isQualitySpeedBottomSheetOpened = false
        }
    }

    override fun onDown(p0: MotionEvent): Boolean = false

    override fun onShowPress(p0: MotionEvent) = Unit

    private var lastClicked: Long = -1L
    override fun onSingleTapUp(event: MotionEvent): Boolean {
        lastClicked = if (lastClicked == -1L) {
            System.currentTimeMillis()
        } else {
            if (isDoubleClicked(lastClicked)) {
                if (event.x < sWidth / 2) {
                    player?.seekTo(player!!.currentPosition - 10000)
                } else {
                    player?.seekTo(player!!.currentPosition + 10000)
                }
            } else {
                if (!isPipMode) {
                    playerView?.showController()
                }
            }
            -1L
        }
        Handler(Looper.getMainLooper()).postDelayed({
            if (lastClicked != -1L) {
                if (!isPipMode) {
                    playerView?.showController()
                }
                lastClicked = -1L
            }
        }, 300)
        return false
    }

    private fun isDoubleClicked(lastClicked: Long): Boolean =
        lastClicked - System.currentTimeMillis() <= 300

    override fun onLongPress(p0: MotionEvent) = Unit

    override fun onFling(e1: MotionEvent?, p0: MotionEvent, p2: Float, p3: Float): Boolean = false

    override fun onScroll(
        e1: MotionEvent?, event: MotionEvent, distanceX: Float, distanceY: Float
    ): Boolean {
        if (abs(distanceX) < abs(distanceY)) {
            if (event.x < sWidth / 2) {
                layoutBrightness?.visibility = View.VISIBLE
                layoutVolume?.visibility = View.GONE
                val increase = distanceY > 0
                val newValue: Double = if (increase) brightness + 0.2 else brightness - 0.2
                if (newValue in 0.0..maxBrightness) brightness = newValue
                brightnessSeekbar?.progress = brightness.toInt()
                setScreenBrightness(brightness.toInt())
            } else {
                layoutBrightness?.visibility = View.GONE
                layoutVolume?.visibility = View.VISIBLE
                val increase = distanceY > 0
                val newValue = if (increase) volume + 0.2 else volume - 0.2
                if (newValue in 0.0..maxVolume) volume = newValue
                volumeSeekBar?.progress = volume.toInt()
                audioManager!!.setStreamVolume(AudioManager.STREAM_MUSIC, volume.toInt(), 0)
            }
        }
        return true
    }

    private fun setScreenBrightness(value: Int) {
        val d = 1.0f / 30
        val lp = this.window.attributes
        lp.screenBrightness = d * value
        this.window.attributes = lp
    }

    private var scaleFactor: Float = 0f
    override fun onScale(detector: ScaleGestureDetector): Boolean {
        scaleFactor = detector.scaleFactor
        return true
    }

    override fun onScaleBegin(p0: ScaleGestureDetector): Boolean {
        return true
    }

    override fun onScaleEnd(p0: ScaleGestureDetector) {
        if (scaleFactor > 1) {
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
        } else {
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
        }
    }

    override fun onAudioFocusChange(focusChange: Int) {
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> {
                player?.pause()
                playerView?.hideController()
            }
        }
    }

    private fun setAudioFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioManager!!.requestAudioFocus(
                AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN).setAudioAttributes(
                    AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_GAME)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build()
                ).setAcceptsDelayedFocusGain(true).setOnAudioFocusChangeListener(this).build()
            )
        } else {
            @Suppress("DEPRECATION") audioManager!!.requestAudioFocus(
                this, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN
            )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // BroadcastReceiver ni to'xtatish
        unregisterReceiver(networkChangeReceiver)
    }
}
