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
import android.util.Log
import android.util.Rational
import android.view.*
import android.widget.*
import android.widget.SeekBar.OnSeekBarChangeListener
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.dash.DashMediaSource
import androidx.media3.exoplayer.drm.DrmSessionManager
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.mediarouter.app.MediaRouteButton
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager2.widget.ViewPager2
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaLoadRequestData
import com.google.android.gms.cast.MediaMetadata
import com.google.android.gms.cast.MediaSeekOptions
import com.google.android.gms.cast.framework.*
import com.google.android.gms.cast.framework.media.RemoteMediaClient
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.adapters.*
import uz.udevs.udevs_video_player.double_tap_playerview.DoubleTapPlayerView
import uz.udevs.udevs_video_player.double_tap_playerview.youtybe.VideoPlayerOverlay
import uz.udevs.udevs_video_player.models.*
import uz.udevs.udevs_video_player.retrofit.Common
import uz.udevs.udevs_video_player.retrofit.RetrofitService
import uz.udevs.udevs_video_player.services.DownloadUtil
import uz.udevs.udevs_video_player.services.NetworkChangeReceiver
import java.util.Locale
import kotlin.math.abs

@UnstableApi
class UdevsVideoPlayerActivity : AppCompatActivity(), AudioManager.OnAudioFocusChangeListener {

    private lateinit var player: ExoPlayer
    private lateinit var playerView: DoubleTapPlayerView
    private lateinit var playerOverlay: VideoPlayerOverlay
    private lateinit var networkChangeReceiver: NetworkChangeReceiver
    private lateinit var intentFilter: IntentFilter
    private lateinit var playerConfiguration: PlayerConfiguration
    private var close: ImageView? = null
    private var pip: ImageView? = null
    private var cast: MediaRouteButton? = null
    private var more: ImageView? = null
    private var lockTouch: ImageView? = null
    private var title: TextView? = null
    private var title1: TextView? = null
    private var rewind: ImageView? = null
    private var forward: ImageView? = null
    private var playPause: ImageView? = null
    private var progressbar: ProgressBar? = null

    private var exoPosition: TextView? = null
    private var exoDuration: TextView? = null
    private var live: LinearLayout? = null
    private var episodesButton: LinearLayout? = null
    private var episodesText: TextView? = null
    private var nextButton: LinearLayout? = null
    private var nextText: TextView? = null
    private var tvProgramsButton: LinearLayout? = null
    private var tvProgramsText: TextView? = null
    private var zoom: ImageView? = null
    private var orientation: ImageView? = null
    private var exoProgress: DefaultTimeBar? = null
    private var customSeekBar: SeekBar? = null
    private var customPlayback: RelativeLayout? = null
    private var layoutBrightness: LinearLayout? = null
    private var brightnessSeekbar: SeekBar? = null
    private var volumeSeekBar: SeekBar? = null
    private var layoutVolume: LinearLayout? = null
    private var audioManager: AudioManager? = null
    private var brightness: Double = 15.0
    private var maxBrightness: Double = 31.0
    private var volume: Double = 0.0
    private var maxVolume: Double = 0.0
    private var sWidth: Int = 0
    private var seasonIndex: Int = 0
    private var episodeIndex: Int = 0
    private var channelIndex: Int = 0
    private var retrofitService: RetrofitService? = null
    private val TAG = "TAG1"
    private var currentOrientation: Int = Configuration.ORIENTATION_PORTRAIT
    private var titleText = ""
    private lateinit var url: String
    private var sameWithStreamingContent = false
    private var isTouchLocked = false

    private var mLocation: PlaybackLocation? = null
    private var mPlaybackState: PlaybackState? = null
    private var mSessionManagerListener: SessionManagerListener<CastSession>? = null
    private var mCastSession: CastSession? = null
    private var mCastContext: CastContext? = null

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
        Log.d(TAG, "onCreate: ${remoteMediaClient?.mediaInfo?.contentUrl}")
        if (mLocation == PlaybackLocation.REMOTE) {
            playerConfiguration.resolutions.values.forEach {
                Log.d(TAG, "onCreate: $it")
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
        brightnessSeekbar?.max = 30
        brightnessSeekbar?.progress = 15
        audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        setAudioFocus()
        maxVolume = audioManager!!.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toDouble()
        volume = audioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC).toDouble()
        volumeSeekBar?.max = maxVolume.toInt()
        maxVolume += 1.0
        volumeSeekBar?.progress = volume.toInt()
        playVideo()
        initDoubleTapPlayerView()
    }

    private fun initDoubleTapPlayerView() {
        playerOverlay.performListener(
            object : VideoPlayerOverlay.PerformListener {
                override fun shouldForward(
                    player: Player, playerView: DoubleTapPlayerView, posX: Float
                ): Boolean? {
                    if (!isTouchLocked) {
                        if (player.playbackState == android.media.session.PlaybackState.STATE_ERROR || player.playbackState == android.media.session.PlaybackState.STATE_NONE || player.playbackState == android.media.session.PlaybackState.STATE_STOPPED) {

                            playerView.cancelInDoubleTapMode()
                            return null
                        }

                        if (player.currentPosition > 500 && posX < playerView.width * 0.35) return false

                        if (player.currentPosition < player.duration && posX > playerView.width * 0.65) return true

                        return null
                    } else {
                        return null
                    }
                }

                override fun onScaleEnd(scaleFactor: Float) {
                    if (!isTouchLocked) {
                        if (scaleFactor > 1) {
                            playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
                        } else {
                            playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
                        }
                    }
                }

                override fun onActionUp() {
                    if (!isTouchLocked) {
                        layoutBrightness?.visibility = View.GONE
                        layoutVolume?.visibility = View.GONE
                    }
                }

                override fun onAnimationStart() {
                    if (!isTouchLocked) {
                        playerView.useController = false
                        playerOverlay.visibility = View.VISIBLE
                    }
                }

                override fun onAnimationEnd() {
                    if (!isTouchLocked) {
                        playerOverlay.visibility = View.GONE
                        playerView.useController = true
                    }
                }

                override fun onScroll(
                    e1: MotionEvent, e2: MotionEvent, distanceX: Float, distanceY: Float
                ): Boolean {
                    if (!isTouchLocked) {
                        if (abs(distanceX) < abs(distanceY)) {
                            if (e1.x < sWidth / 2) {
                                layoutBrightness?.visibility = View.VISIBLE
                                layoutVolume?.visibility = View.GONE
                                val increase = distanceY > 0
                                val newValue: Double =
                                    if (increase) brightness + 0.2 else brightness - 0.2
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
                                audioManager!!.setStreamVolume(
                                    AudioManager.STREAM_MUSIC, volume.toInt(), 0
                                )
                            }
                        }
                        return true
                    } else {
                        return false
                    }
                }
            },
        )

        playerView.doubleTapDelay = 500
    }

    fun isNetworkAvailable(context: Context?): Boolean {
        if (context == null) return false
        val connectivityManager =
            context.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
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
                Log.d(TAG, "onApplicationConnected: $mPlaybackState")
                mCastSession = castSession
                mLocation = PlaybackLocation.REMOTE
                player.pause()
                performViewsOnConnect()
                loadRemoteMedia(player.currentPosition)
                registerCallBack()
                listenToProgress()
            }

            private fun onApplicationDisconnected() {
                Log.d(TAG, "onApplicationDisconnected: $mPlaybackState")
                mPlaybackState = PlaybackState.IDLE
                mLocation = PlaybackLocation.LOCAL
                performViewsOnDisconnect()
                player.seekTo((customSeekBar!!.progress * 1000).toLong())
                player.play()
            }
        }
    }

    private fun performViewsOnConnect() {
        pip?.visibility = View.GONE
        exoPosition?.visibility = View.GONE
        exoProgress?.visibility = View.GONE
        customSeekBar?.visibility = View.VISIBLE
        customSeekBar?.isEnabled = true
        customSeekBar?.max = (player.duration / 1000).toInt()
        customSeekBar?.progress = (player.currentPosition / 1000).toInt()
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
                if (!isTouchLocked) {
                    Log.d(TAG, "loadRemoteMedia: $max -> $current")
                    customSeekBar?.progress = (current / 1000).toInt()
//                videoPosition?.text = MyHelper().formatDuration(current / 1000)
                    listener = this
                }
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
        if (player.isPlaying) {
            player.stop()
        }
        val seconds = player.currentPosition / 1000
        removeProgressListener()
        unregisterCallBack()
        val intent = Intent()
        intent.putExtra("position", seconds)
        setResult(PLAYER_ACTIVITY_FINISH, intent)
        finish()
        super.onBackPressed()
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onPause() {
        super.onPause()
        player.playWhenReady = false
        if (isInPictureInPictureMode) {
            player.playWhenReady = true
        }
        mCastContext!!.sessionManager.removeSessionManagerListener(
            mSessionManagerListener!!, CastSession::class.java
        )
    }

    override fun onResume() {
        setAudioFocus()
        if (mLocation == PlaybackLocation.LOCAL) player.playWhenReady = true
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
        if (mLocation == PlaybackLocation.LOCAL) player.playWhenReady = true
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onStop() {
        super.onStop()
        if (isInPictureInPictureMode) {
            removeProgressListener()
            unregisterCallBack()
            player.release()
            finish()
        }
    }

    private fun playVideo() {
        val dataSourceFactory: DataSource.Factory =
            if (!playerConfiguration.fromCache) DefaultHttpDataSource.Factory()
            else DownloadUtil.getDataSourceFactory(this)

        var hlsMediaSource: HlsMediaSource? = null
        var dashMediaSource: DashMediaSource? = null
        if (playerConfiguration.isDRM) {
            val mediaItem: MediaItem.Builder =
                MediaItem.Builder().setUri(Uri.parse(url))

            val requestHeaders: MutableMap<String, String> = java.util.HashMap()
            requestHeaders["X-AxDRM-Message"] = playerConfiguration.licenseToken
            mediaItem.setDrmConfiguration(
                MediaItem.DrmConfiguration.Builder(C.WIDEVINE_UUID)
                    .setLicenseUri(playerConfiguration.widevineLicenseUrl)
                    .setLicenseRequestHeaders(requestHeaders)
                    .setForceSessionsForAudioAndVideoTracks(false)
                    .setMultiSession(false)
                    .setForceDefaultLicenseUri(false)
                    .build()
            )
            dashMediaSource =
                DashMediaSource.Factory(dataSourceFactory).createMediaSource(mediaItem.build())
        } else {
            hlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
        }

        player = ExoPlayer.Builder(this).build()
        playerView.player = player
        playerView.keepScreenOn = true
        playerView.useController = playerConfiguration.showController
        playerOverlay.player(player)
        if (hlsMediaSource != null) {
            player.setMediaSource(hlsMediaSource)
        } else if (dashMediaSource != null) {
            player.setMediaSource(dashMediaSource)
        }
        player.seekTo(playerConfiguration.lastPosition * 1000)
        player.prepare()
        player.addListener(object : Player.Listener {
            override fun onPlayerError(error: PlaybackException) {
                Log.d(TAG, "onPlayerError: ${error.errorCode}")
                player.pause()
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
//                        if (playerView?.isControllerFullyVisible == false) {
//                            playerView?.setShowBuffering(SHOW_BUFFERING_ALWAYS)
//                        }
                    }

                    Player.STATE_READY -> {
                        if (mLocation == PlaybackLocation.REMOTE && customSeekBar?.visibility == View.GONE) {
                            performViewsOnConnect()
                        }
                        playPause?.visibility = View.VISIBLE
                        progressbar?.visibility = View.GONE
//                        if (playerView?.isControllerFullyVisible == false) {
//                            playerView?.setShowBuffering(SHOW_BUFFERING_NEVER)
//                        }
                    }

                    Player.STATE_ENDED -> {
                        playPause?.setImageResource(R.drawable.ic_play)
                    }

                    Player.STATE_IDLE -> {
                        mPlaybackState = PlaybackState.IDLE
                    }
                }
            }
        })
        if (mLocation == PlaybackLocation.LOCAL) {
            player.playWhenReady = true
        } else {
            if (!sameWithStreamingContent) {
                loadRemoteMedia(playerConfiguration.lastPosition)
            }
            registerCallBack()
            listenToProgress()
        }
    }


    private fun rePlayVideo() {
        player.prepare()
        player.play()
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun initializeViews() {
        playerOverlay = findViewById(R.id.ytOverlay)
        playerView = findViewById(R.id.previewPlayerView)
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
        CastButtonFactory.setUpMediaRouteButton(applicationContext, cast!!)
        more = findViewById(R.id.video_more)
        lockTouch = findViewById(R.id.lock_touch)
        title = findViewById(R.id.video_title)
        title1 = findViewById(R.id.video_title1)
        title?.text = titleText
        title1?.text = titleText

        rewind = findViewById(R.id.video_rewind)
        forward = findViewById(R.id.video_forward)
        playPause = findViewById(R.id.video_play_pause)
        progressbar = findViewById(R.id.video_progress_bar)
//        timer = findViewById(R.id.timer)
//        if (playerConfiguration.isLive) {
//            timer?.visibility = View.GONE
//        }
        exoDuration = findViewById(R.id.exo_duration)
        exoPosition = findViewById(R.id.exo_position)
        live = findViewById(R.id.live)
        if (playerConfiguration.isLive) {
            live?.visibility = View.VISIBLE
        }
        episodesButton = findViewById(R.id.button_episodes)
        episodesText = findViewById(R.id.text_episodes)
        if (playerConfiguration.seasons.isNotEmpty()) {
            episodesButton?.visibility = View.VISIBLE
            episodesText?.text = playerConfiguration.episodeButtonText
        }
        nextButton = findViewById(R.id.button_next)
        nextText = findViewById(R.id.text_next)

        if (playerConfiguration.seasons.isNotEmpty()) if (playerConfiguration.isSerial && !(seasonIndex == playerConfiguration.seasons.size - 1 && episodeIndex == playerConfiguration.seasons[seasonIndex].movies.size - 1)) {
            nextText?.text = playerConfiguration.nextButtonText
        }
        tvProgramsButton = findViewById(R.id.button_tv_programs)
        tvProgramsText = findViewById(R.id.text_tv_programs)
        if (playerConfiguration.isLive) {
            tvProgramsButton?.visibility = View.VISIBLE
            tvProgramsText?.text = playerConfiguration.tvProgramsText
        }
        zoom = findViewById(R.id.zoom)
        orientation = findViewById(R.id.orientation)
        exoProgress = findViewById(R.id.exo_progress)
        customSeekBar = findViewById(R.id.progress_bar)
        customSeekBar?.isEnabled = false
        if (playerConfiguration.isLive) {
            exoPosition?.visibility = View.GONE
            exoDuration?.visibility = View.GONE
            exoProgress?.visibility = View.GONE
            rewind?.visibility = View.GONE
            forward?.visibility = View.GONE
            customSeekBar?.visibility = View.VISIBLE
        }
    }

    private fun lockAndUnlockTouch() {
        isTouchLocked = !isTouchLocked
        if (!isTouchLocked) {
            exoProgress?.visibility = View.VISIBLE
            close?.visibility = View.VISIBLE
            pip?.visibility = View.VISIBLE
            cast?.visibility = View.VISIBLE
            more?.visibility = View.VISIBLE
            rewind?.visibility = View.VISIBLE
            forward?.visibility = View.VISIBLE
            playPause?.visibility = View.VISIBLE
            orientation?.visibility = View.VISIBLE
            exoPosition?.visibility = View.VISIBLE
            exoDuration?.visibility = View.VISIBLE
            zoom?.visibility = View.VISIBLE
            if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
                title1?.visibility = View.VISIBLE
            } else {
                title?.visibility = View.VISIBLE
            }
            if (playerConfiguration.isLive) {
                live?.visibility = View.VISIBLE
                exoPosition?.visibility = View.GONE
                exoDuration?.visibility = View.GONE
                exoProgress?.visibility = View.GONE
                rewind?.visibility = View.GONE
                forward?.visibility = View.GONE
                customSeekBar?.visibility = View.VISIBLE
                tvProgramsButton?.visibility = View.VISIBLE
                tvProgramsText?.visibility = View.VISIBLE
            }
            if (playerConfiguration.seasons.isNotEmpty()) {
                episodesButton?.visibility = View.VISIBLE
                episodesText?.visibility = View.VISIBLE
                nextText?.visibility = View.VISIBLE
            }
            lockTouch?.setImageResource(R.drawable.ic_lock_open)
        } else {
            exoProgress?.visibility = View.INVISIBLE
            close?.visibility = View.INVISIBLE
            pip?.visibility = View.INVISIBLE
            cast?.visibility = View.INVISIBLE
            more?.visibility = View.INVISIBLE
            rewind?.visibility = View.INVISIBLE
            forward?.visibility = View.INVISIBLE
            playPause?.visibility = View.INVISIBLE
            orientation?.visibility = View.INVISIBLE
            exoPosition?.visibility = View.INVISIBLE
            exoDuration?.visibility = View.INVISIBLE
            zoom?.visibility = View.INVISIBLE
            if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
                title1?.visibility = View.INVISIBLE
            } else {
                title?.visibility = View.INVISIBLE
            }
            if (playerConfiguration.isLive) {
                live?.visibility = View.INVISIBLE
                exoPosition?.visibility = View.GONE
                exoDuration?.visibility = View.GONE
                exoProgress?.visibility = View.GONE
                rewind?.visibility = View.GONE
                forward?.visibility = View.GONE
                customSeekBar?.visibility = View.INVISIBLE
                tvProgramsButton?.visibility = View.INVISIBLE
                tvProgramsText?.visibility = View.INVISIBLE
            }
            if (playerConfiguration.seasons.isNotEmpty()) {
                episodesButton?.visibility = View.INVISIBLE
                episodesText?.visibility = View.INVISIBLE
                nextText?.visibility = View.INVISIBLE
            }
            lockTouch?.setImageResource(R.drawable.ic_lock)
        }
    }

    @SuppressLint("SetTextI18n", "ClickableViewAccessibility")
    private fun initializeClickListeners() {
        close?.setOnClickListener {
            if (!isTouchLocked) {
                if (player.isPlaying) {
                    player.stop()
                }
                val seconds = player.currentPosition / 1000

                removeProgressListener()
                unregisterCallBack()
                val intent = Intent()
                intent.putExtra("position", seconds)
                setResult(PLAYER_ACTIVITY_FINISH, intent)
                finish()
            }
        }
        pip?.setOnClickListener {
            if (!isTouchLocked) {
                if (mLocation == PlaybackLocation.REMOTE) {
                    return@setOnClickListener
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val params =
                        PictureInPictureParams.Builder().setAspectRatio(Rational(16, 9)).build()
                    enterPictureInPictureMode(params)
                } else {
                    Toast.makeText(this, "This is my Toast message!", Toast.LENGTH_SHORT).show()
                }
            }
        }
        more?.setOnClickListener {
            if (!isTouchLocked) {
                showSettingsBottomSheet()
            }
        }
        lockTouch?.setOnClickListener {
            lockAndUnlockTouch()
        }
        rewind?.setOnClickListener {
            if (!isTouchLocked) {
                if (mLocation == PlaybackLocation.LOCAL) {
                    player.seekTo(player.currentPosition - 10000)
                } else {
                    val remoteMediaClient = mCastSession!!.remoteMediaClient
                    val seekOptions: MediaSeekOptions = MediaSeekOptions.Builder()
                        .setPosition((customSeekBar!!.progress * 1000 - 10000).toLong()).build()
                    remoteMediaClient?.seek(seekOptions)
                }
            }
        }
        forward?.setOnClickListener {
            if (!isTouchLocked) {
                if (mLocation == PlaybackLocation.LOCAL) {
                    player.seekTo(player.currentPosition + 10000)
                } else {
                    val remoteMediaClient = mCastSession!!.remoteMediaClient
                    val seekOptions: MediaSeekOptions = MediaSeekOptions.Builder()
                        .setPosition((customSeekBar!!.progress * 1000 + 10000).toLong()).build()
                    remoteMediaClient?.seek(seekOptions)
                }
            }
        }
        playPause?.setOnClickListener {
            if (!isTouchLocked) {
                if (mLocation == PlaybackLocation.LOCAL) {
                    if (player.isPlaying) {
                        player.pause()
                    } else {
                        player.play()
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
        }
        live?.setOnClickListener {
            if (!isTouchLocked) {
                if (playerConfiguration.isLive) showChannelsBottomSheet()
            }
        }
        episodesButton?.setOnClickListener {
            if (!isTouchLocked) {
                if (playerConfiguration.seasons.isNotEmpty()) showEpisodesBottomSheet()
            }
        }
        nextButton?.setOnClickListener {
            if (!isTouchLocked) {
                if (playerConfiguration.seasons.isEmpty()) {
                    return@setOnClickListener
                }
                if (seasonIndex < playerConfiguration.seasons.size) {
                    if (episodeIndex < playerConfiguration.seasons[seasonIndex].movies.size - 1) {
                        episodeIndex++
                    } else {
                        seasonIndex++
                    }
                }
                if (isLastEpisode()) {
                    nextButton?.visibility = View.GONE
                } else {
                    nextButton?.visibility = View.VISIBLE
                }
                title?.text =
                    "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.seasons[seasonIndex].movies[episodeIndex].title
                if (playerConfiguration.isMegogo && playerConfiguration.isSerial) {
                    getMegogoStream()
                } else if (playerConfiguration.isPremier && playerConfiguration.isSerial) {
                    getPremierStream()
                } else {
                    url =
                        playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality]
                            ?: ""
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                    player.setMediaSource(hlsMediaSource)
                    player.prepare()
                    if (mLocation == PlaybackLocation.LOCAL) {
                        player.playWhenReady
                    } else {
                        loadRemoteMedia(0)
                    }
                }
            }
        }
        tvProgramsButton?.setOnClickListener {
            if (!isTouchLocked) {
                if (playerConfiguration.programsInfoList.isNotEmpty()) showTvProgramsBottomSheet()
            }
        }
        zoom?.setOnClickListener {
            if (!isTouchLocked) {
                if (mLocation == PlaybackLocation.REMOTE) {
                    return@setOnClickListener
                }
                when (playerView.resizeMode) {
                    AspectRatioFrameLayout.RESIZE_MODE_ZOOM -> {
                        zoom?.setImageResource(R.drawable.ic_fit)
                        playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
                    }

                    AspectRatioFrameLayout.RESIZE_MODE_FILL -> {
                        zoom?.setImageResource(R.drawable.ic_crop_fit)
                        playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
                    }

                    AspectRatioFrameLayout.RESIZE_MODE_FIT -> {
                        zoom?.setImageResource(R.drawable.ic_stretch)
                        playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
                    }

                    AspectRatioFrameLayout.RESIZE_MODE_FIXED_HEIGHT -> {}
                    AspectRatioFrameLayout.RESIZE_MODE_FIXED_WIDTH -> {}
                }
            }
        }
        orientation?.setOnClickListener {
            if (!isTouchLocked) {
                requestedOrientation =
                    if (resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                        ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    } else {
                        if (playerConfiguration.isLive) {
                            playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
                        }
                        ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    }
                it.postDelayed({
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
                }, 3000)
            }
        }
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override fun onUserLeaveHint() {
        if (mLocation == PlaybackLocation.REMOTE) {
            return
        }
        val params = PictureInPictureParams.Builder().setAspectRatio(Rational(100, 50)).build()
        enterPictureInPictureMode(params)
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean, newConfig: Configuration
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
            if (isInPictureInPictureMode) {
                playerView.hideController()
                playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
            } else {
                playerView.showController()
                playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
            }
        }
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
                    player.setMediaSource(hlsMediaSource)
                    player.prepare()
                    player.playWhenReady
                }
            }

            override fun onFailure(call: Call<MegogoStreamResponse>, t: Throwable) {
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
                    player.setMediaSource(hlsMediaSource)
                    player.prepare()
                    player.playWhenReady
                }
            }

            override fun onFailure(call: Call<PremierStreamResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    private fun getSingleTvChannel(index: Int) {
        retrofitService?.getSingleTvChannel(
            playerConfiguration.authorization,
            playerConfiguration.channels[index].id,
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
                    title?.text = playerConfiguration.channels[index].name
                    title1?.text = playerConfiguration.channels[index].name
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                    player.setMediaSource(hlsMediaSource)
                    player.prepare()
                    player.playWhenReady
                }
            }

            override fun onFailure(call: Call<TvChannelResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        currentOrientation = newConfig.orientation
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            setFullScreen()
            if (playerConfiguration.isLive) {
                playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
            }
            title?.text = title1?.text
            title?.visibility = View.VISIBLE
            title1?.text = ""
            title1?.visibility = View.GONE
            if (playerConfiguration.isSerial) if (isLastEpisode()) nextButton?.visibility =
                View.VISIBLE
            else nextButton?.visibility = View.GONE
            else nextButton?.visibility = View.GONE
            zoom?.visibility = View.VISIBLE
            orientation?.setImageResource(R.drawable.ic_portrait)
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
//                    backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
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
            nextButton?.visibility = View.GONE
            zoom?.visibility = View.GONE
            orientation?.setImageResource(R.drawable.ic_portrait)
            playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
//                    backButtonEpisodeBottomSheet?.visibility = View.GONE
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
        val bottomSheetDialog = BottomSheetDialog(this, R.style.BottomSheetDialog)
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

    //    private var backButtonEpisodeBottomSheet: ImageView? = null
    private fun showEpisodesBottomSheet() {
        currentBottomSheet = BottomSheet.EPISODES
        val bottomSheetDialog = BottomSheetDialog(this, R.style.BottomSheetDialog)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.episodes)
//        backButtonEpisodeBottomSheet = bottomSheetDialog.findViewById(R.id.episode_sheet_back)
//        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
//            backButtonEpisodeBottomSheet?.visibility = View.GONE
//        } else {
//            backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
//        }
//        backButtonEpisodeBottomSheet?.setOnClickListener {
//            bottomSheetDialog.dismiss()
//        }
//        val titleBottomSheet = bottomSheetDialog.findViewById<TextView>(R.id.episodes_sheet_title)
//        titleBottomSheet?.text = title?.text
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.episode_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.episode_view_pager)
        viewPager?.adapter = EpisodePagerAdapter(
            viewPager!!, this,
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
                            "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.seasons[seasonIndex].movies[episodeIndex].title
                        title?.text = titleText
                        title1?.text = title?.text
                        title1?.visibility = View.VISIBLE
                        title?.text = ""
                        title?.visibility = View.INVISIBLE
                    } else {
                        titleText =
                            "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration.seasons[seasonIndex].movies[episodeIndex].title
                        title?.text = titleText
                        title?.visibility = View.VISIBLE
                        title1?.text = ""
                        title1?.visibility = View.GONE
                    }
                    if (playerConfiguration.isMegogo && playerConfiguration.isSerial) {
                        getMegogoStream()
                    } else if (playerConfiguration.isPremier && playerConfiguration.isSerial) {
                        getPremierStream()
                    } else {
                        url =
                            playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality]
                                ?: ""
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                        player.setMediaSource(hlsMediaSource)
                        player.prepare()
                        if (mLocation == PlaybackLocation.LOCAL) {
                            player.playWhenReady
                        } else {
                            loadRemoteMedia(0)
                        }
                    }
                    bottomSheetDialog.dismiss()
                }
            },
        )
        TabLayoutMediator(tabLayout!!, viewPager) { tab, position ->
            tab.text = playerConfiguration.seasons[position].title.replaceFirstChar {
                if (it.isLowerCase()) it.titlecase(
                    Locale.getDefault()
                ) else it.toString()
            }
        }.attach()
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private fun showChannelsBottomSheet() {
        currentBottomSheet = BottomSheet.CHANNELS
        val bottomSheetDialog = BottomSheetDialog(this, R.style.BottomSheetDialog)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.bottom_sheet_channels)
        val viewPager = bottomSheetDialog.findViewById<RecyclerView>(R.id.bottom_sheet_channels_rv)
        viewPager?.adapter = ChannelsRvAdapter(
            this,
            playerConfiguration.channels,
            object : ChannelsRvAdapter.OnClickListener {
                @SuppressLint("SetTextI18n")
                override fun onClick(index: Int) {
                    if (index == channelIndex) {
                        bottomSheetDialog.dismiss()
                    } else {
                        channelIndex = index
                        getSingleTvChannel(index)
                        bottomSheetDialog.dismiss()
                    }
                }
            },
        )
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private var speeds =
        mutableListOf("0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x")
    private var currentQuality = ""
    private var currentSpeed = "1.0x"
    private var qualityText: TextView? = null
    private var speedText: TextView? = null

    private var backButtonSettingsBottomSheet: ImageView? = null
    private fun showSettingsBottomSheet() {
        currentBottomSheet = BottomSheet.SETTINGS
        val bottomSheetDialog = BottomSheetDialog(this, R.style.BottomSheetDialog)
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
        bottomSheetDialog.findViewById<TextView>(R.id.quality_settings_text)?.text =
            playerConfiguration.qualityText
        bottomSheetDialog.findViewById<TextView>(R.id.speed_settings_text)?.text =
            playerConfiguration.speedText
        qualityText = bottomSheetDialog.findViewById(R.id.quality_settings_value_text)
        speedText = bottomSheetDialog.findViewById(R.id.speed_settings_value_text)
        qualityText?.text = currentQuality
        speedText?.text = currentSpeed
        quality?.setOnClickListener {
            if (playerConfiguration.isSerial) {
                if (playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions.isNotEmpty()) showQualitySpeedSheet(
                    currentQuality,
                    playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions.keys.toList() as ArrayList,
                    true,
                )
            } else {
                if (playerConfiguration.resolutions.size > 1) showQualitySpeedSheet(
                    currentQuality,
                    playerConfiguration.resolutions.keys.toList() as ArrayList,
                    true,
                )
            }
        }
        speed?.setOnClickListener {
            if (mLocation == PlaybackLocation.LOCAL) showQualitySpeedSheet(
                currentSpeed, speeds as ArrayList, false
            )
        }
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private var backButtonQualitySpeedBottomSheet: ImageView? = null
    private fun showQualitySpeedSheet(
        initialValue: String, list: ArrayList<String>, fromQuality: Boolean
    ) {
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this, R.style.BottomSheetDialog)
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
        val l = mutableListOf<String>()

        if (fromQuality) {
            var auto = ""
            var k4 = ""
            var k8 = ""
            list.forEach {
                if (it.lowercase() == "4k") {
                    k4 = it
                } else if (it.lowercase() == "8k") {
                    k8 = it
                } else if (it.substring(0, it.length - 1).toIntOrNull() != null) {
                    l.add(it)
                } else {
                    auto = it
                }
            }
            for (i in 0 until l.size) {
                for (j in i until l.size) {
                    val first = l[i]
                    val second = l[j]
                    if (first.substring(0, first.length - 1).toInt() < second.substring(
                            0, second.length - 1
                        ).toInt()
                    ) {
                        val a = l[i]
                        l[i] = l[j]
                        l[j] = a
                    }
                }
            }
            if (auto.isNotEmpty()) {
                l.add(0, auto)
            }
            if (auto.isNotEmpty() && k4.isNotEmpty()) {
                l.add(1, k4)
            } else if (k4.isNotEmpty()) {
                l.add(0, k4)
            }
            if (k4.isNotEmpty() && k8.isNotEmpty()) {
                l.add(1, k8)
            } else if (auto.isNotEmpty() && k8.isNotEmpty()) {
                l.add(1, k8)
            } else {
                l.add(0, k8)
            }
        } else {
            l.addAll(list)
        }
        val adapter = QualitySpeedAdapter(
            initialValue,
            this,
            l as ArrayList<String>,
            (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        currentQuality = l[position]
                        qualityText?.text = currentQuality
                        if (player.isPlaying) {
                            player.pause()
                        }
                        val currentPosition = player.currentPosition
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        url =
                            if (playerConfiguration.isSerial) playerConfiguration.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality]
                                ?: "" else playerConfiguration.resolutions[currentQuality] ?: ""
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
                        player.setMediaSource(hlsMediaSource)
                        player.seekTo(currentPosition)
                        if (mLocation == PlaybackLocation.LOCAL) {
                            player.play()
                        } else {
                            if (playerConfiguration.isSerial) {
                                loadRemoteMedia(currentPosition)
                            } else {
                                loadRemoteMedia(currentPosition)
                            }
                        }
                    } else {
                        if (mLocation == PlaybackLocation.REMOTE) {
                            return
                        }
                        currentSpeed = l[position]
                        speedText?.text = currentSpeed
                        player.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
        }
    }

    private fun setScreenBrightness(value: Int) {
        val d = 1.0f / 30
        val lp = this.window.attributes
        lp.screenBrightness = d * value
        this.window.attributes = lp
    }


    override fun onAudioFocusChange(focusChange: Int) {
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> {
                player.pause()
                playerView.hideController()
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
