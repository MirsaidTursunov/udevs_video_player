package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Color
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.*
import android.widget.*
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerView
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.adapters.*
import uz.udevs.udevs_video_player.models.*
import uz.udevs.udevs_video_player.retrofit.Common
import uz.udevs.udevs_video_player.retrofit.RetrofitService
import java.security.SecureRandom
import java.security.cert.CertificateException
import java.security.cert.X509Certificate
import java.util.*
import javax.net.ssl.*
import kotlin.collections.ArrayList
import kotlin.collections.List
import kotlin.math.abs


open class UdevsVideoPlayerActivity : Activity(), GestureDetector.OnGestureListener,
    ScaleGestureDetector.OnScaleGestureListener {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var close: ImageView? = null
    private var more: ImageView? = null
    private var title: TextView? = null
    private var rewind: ImageView? = null
    private var forward: ImageView? = null
    private var playPause: ImageView? = null
    private var progressbar: ProgressBar? = null
    private var progressbar2: ProgressBar? = null
    private var timer: LinearLayout? = null
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
    private var customPlayback: ConstraintLayout? = null
    private var layoutBrightness: LinearLayout? = null
    private var brightnessSeekbar: SeekBar? = null
    private var volumeSeekBar: SeekBar? = null
    private var layoutVolume: LinearLayout? = null
    private var audioManager: AudioManager? = null
    private var gestureDetector: GestureDetector? = null
    private var scaleGestureDetector: ScaleGestureDetector? = null
    private var brightness: Double = 15.0
    private var maxBrightness: Double = 31.0
    private var volume: Double = 0.0
    private var maxVolume: Double = 0.0
    private var sWidth: Int = 0
    private var seasonIndex: Int = 0
    private var episodeIndex: Int = 0
    private var retrofitService: RetrofitService? = null
    private lateinit var currentSeason: Season
    private lateinit var rvEpisodesRvAdapter: EpisodesRvAdapter
    private var selectedSeasonIndex: Int = 0
    private lateinit var tvQualitiesList : List<String>

    var startTime: Int = 0

    var timerHandler = Handler()
    var timerRunnable: Runnable = object : Runnable {
        override fun run() {
            startTime += 1
            if (startTime >= 15) {
                startTime = 0
                movieTrack()
            }
            timerHandler.postDelayed(this, 1000)
        }
    }

    @SuppressLint("ClickableViewAccessibility", "MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player_activity)
        actionBar?.hide()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val window = window
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            window.statusBarColor = Color.BLACK
            window.navigationBarColor = Color.BLACK
        }
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?
        seasonIndex = playerConfiguration!!.seasonIndex
        episodeIndex = playerConfiguration!!.episodeIndex
        currentQuality = playerConfiguration?.initialResolution?.keys?.first()!!

        playerView = findViewById(R.id.exo_player_view)
        customPlayback = findViewById(R.id.custom_playback)
        layoutBrightness = findViewById(R.id.layout_brightness)
        brightnessSeekbar = findViewById(R.id.brightness_seek)
        brightnessSeekbar?.isEnabled = false
        layoutVolume = findViewById(R.id.layout_volume)
        volumeSeekBar = findViewById(R.id.volume_seek)
        volumeSeekBar?.isEnabled = false

        close = findViewById(R.id.video_close)
        more = findViewById(R.id.video_more)
        title = findViewById(R.id.video_title)
        title?.text = playerConfiguration?.title

        rewind = findViewById(R.id.video_rewind)
        forward = findViewById(R.id.video_forward)
        playPause = findViewById(R.id.video_play_pause)
        progressbar = findViewById(R.id.video_progress_bar)
        progressbar2 = findViewById(R.id.video_progress_bar2)
        timer = findViewById(R.id.timer)
        if (playerConfiguration?.type == PlayerType.tv) {
            timer?.visibility = View.GONE
        }
        live = findViewById(R.id.live)
        if (playerConfiguration?.type == PlayerType.tv) {
            live?.visibility = View.VISIBLE
        }
        episodesButton = findViewById(R.id.button_episodes)
        episodesText = findViewById(R.id.text_episodes)
        if (playerConfiguration?.seasons?.isNotEmpty() == true) {
            episodesButton?.visibility = View.VISIBLE
            episodesText?.text = playerConfiguration?.episodeButtonText
        }
        nextButton = findViewById(R.id.button_next)
        nextText = findViewById(R.id.text_next)

        if (playerConfiguration?.type == PlayerType.serial && !(seasonIndex == playerConfiguration!!.seasons.size - 1 &&
                    episodeIndex == playerConfiguration!!.seasons[seasonIndex].movies.size - 1)
        ) {
            nextButton?.visibility = View.VISIBLE
            nextText?.text = playerConfiguration?.nextButtonText
        }

        tvProgramsButton = findViewById(R.id.button_tv_programs)
        tvProgramsText = findViewById(R.id.text_tv_programs)
        if (playerConfiguration?.type == PlayerType.tv) {
            tvProgramsButton?.visibility = View.VISIBLE
            tvProgramsText?.text = playerConfiguration?.tvProgramsText
        }
        zoom = findViewById(R.id.zoom)
        orientation = findViewById(R.id.orientation)
        exoProgress = findViewById(R.id.exo_progress)
        customSeekBar = findViewById(R.id.progress_bar)
        customSeekBar?.isEnabled = false


        setVideoTitle()


        retrofitService = Common.retrofitService(playerConfiguration!!.baseUrl)
        initializeClickListeners()

        sWidth = Resources.getSystem().displayMetrics.widthPixels

        gestureDetector = GestureDetector(this, this)
        scaleGestureDetector = ScaleGestureDetector(this, this)
        brightnessSeekbar?.max = 30
        brightnessSeekbar?.progress = 15
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        maxVolume = audioManager!!.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toDouble()
        volume = audioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC).toDouble()
        volumeSeekBar?.max = maxVolume.toInt()
        maxVolume += 1.0
        volumeSeekBar?.progress = volume.toInt()

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
        trustEveryone()
        if (playerConfiguration?.playVideoFromAsset == true) {
            playFromAsset()
        } else {
            playVideo()
        }
        if (playerConfiguration?.type == PlayerType.serial) {
            currentSeason = playerConfiguration!!.seasons[0]
        }
    }

    private fun setVideoTitle() {
        println("playerConfiguration?.type: ${playerConfiguration?.type}")
        title?.text = when (playerConfiguration?.type) {
            PlayerType.tv -> {
                exoProgress?.visibility = View.GONE
                rewind?.visibility = View.GONE
                forward?.visibility = View.GONE
                nextButton?.visibility = View.GONE
                customSeekBar?.visibility = View.GONE
                ""
            }
            PlayerType.serial -> {
                "S${seasonIndex + 1} E${episodeIndex + 1} " +
                        playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title
            }
            PlayerType.movie -> {
                playerConfiguration!!.title
            }
            PlayerType.trailer -> {
                playerConfiguration!!.title
            }
            else -> ""
        }
    }

    private fun trustEveryone() {
        try {
            HttpsURLConnection.setDefaultHostnameVerifier { _, _ -> true }
            val context: SSLContext = SSLContext.getInstance("TLS")
            context.init(
                null, arrayOf<X509TrustManager>(@SuppressLint("CustomX509TrustManager")
                object : X509TrustManager {
                    @SuppressLint("TrustAllX509TrustManager")
                    @Throws(CertificateException::class)
                    override fun checkClientTrusted(
                        chain: Array<X509Certificate?>?,
                        authType: String?
                    ) {
                    }

                    @SuppressLint("TrustAllX509TrustManager")
                    @Throws(CertificateException::class)
                    override fun checkServerTrusted(
                        chain: Array<X509Certificate?>?,
                        authType: String?
                    ) {
                    }

                    override fun getAcceptedIssuers(): Array<X509Certificate> {
                        TODO("Not yet implemented")
                    }

                }), SecureRandom()
            )
            HttpsURLConnection.setDefaultSSLSocketFactory(
                context.socketFactory
            )
        } catch (e: Exception) { // should never happen
            e.printStackTrace()
        }
    }

    override fun onBackPressed() {
        if (player?.isPlaying == true) {
            player?.stop()
        }
        var seconds = 0L
        if (player?.currentPosition != null) {
            seconds = player?.currentPosition!! / 1000
        }
        val intent = Intent()
        intent.putExtra("position", seconds.toString())
        setResult(PLAYER_ACTIVITY_FINISH, intent)
        timerHandler.removeCallbacks(timerRunnable)
        finish()
        super.onBackPressed()
    }

    override fun onPause() {
        super.onPause()
        player?.playWhenReady = false
    }

    override fun onResume() {
        super.onResume()
        player?.playWhenReady = true
        if (brightness != 0.0) setScreenBrightness(brightness.toInt())
    }

    override fun onRestart() {
        super.onRestart()
        player?.playWhenReady = true
    }

    private fun playFromAsset() {
        val uri = Uri.parse("asset:///flutter_assets/${playerConfiguration!!.assetPath}")
        val dataSourceFactory: DataSource.Factory = DefaultDataSource.Factory(this)
        val mediaSource: MediaSource = ProgressiveMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(uri))
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = false
        playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
        player?.setMediaSource(mediaSource)
        player?.prepare()
        player?.playWhenReady = true
    }

    private fun playVideo() {
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.initialResolution.values.first())))
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = playerConfiguration!!.showController
        player?.setMediaSource(hlsMediaSource)
        player?.seekTo(playerConfiguration!!.lastPosition * 1000)
        player?.prepare()
        player?.addListener(
            object : Player.Listener {
                override fun onPlayerError(error: PlaybackException) {
                    println(error.errorCode)
                }

                override fun onIsPlayingChanged(isPlaying: Boolean) {
                    if (isPlaying) {
                        if (playerConfiguration!!.type == PlayerType.movie || playerConfiguration!!.type == PlayerType.serial) {
                            timerHandler.postDelayed(timerRunnable, 0)
                        }
                        playPause?.setImageResource(R.drawable.ic_pause)
                    } else {
                        if (playerConfiguration!!.type == PlayerType.movie || playerConfiguration!!.type == PlayerType.serial) {
                            timerHandler.removeCallbacks(timerRunnable)
                        }
                        playPause?.setImageResource(R.drawable.ic_play)
                    }
                }

                override fun onPlaybackStateChanged(playbackState: Int) {
                    when (playbackState) {
                        Player.STATE_BUFFERING -> {
                            playPause?.visibility = View.GONE
                            progressbar?.visibility = View.VISIBLE
                            if (playerView?.isControllerFullyVisible == false) {
                                if (progressbar?.visibility == View.GONE) {
                                    progressbar2?.visibility = View.VISIBLE
                                }
//                                playerView?.setShowBuffering(SHOW_BUFFERING_ALWAYS)
                            }
                        }
                        Player.STATE_READY -> {
                            playPause?.visibility = View.VISIBLE
                            progressbar?.visibility = View.GONE
                            if (playerView?.isControllerFullyVisible == false) {
                                progressbar2?.visibility = View.GONE
//                                playerView?.setShowBuffering(SHOW_BUFFERING_NEVER)
                            }
                        }
                        Player.STATE_ENDED -> {
                            playPause?.setImageResource(R.drawable.ic_play)
                        }
                        Player.STATE_IDLE -> {}
                    }
                }
            })
        player?.playWhenReady = true
    }

    private var lastClicked1: Long = -1L

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
        close?.setOnClickListener {
            if (player?.isPlaying == true) {
                player?.stop()
            }
            var seconds = 0L
            if (player?.currentPosition != null) {
                seconds = player?.currentPosition!! / 1000
            }
            val intent = Intent()
            intent.putExtra("position", seconds.toString())
            setResult(PLAYER_ACTIVITY_FINISH, intent)
            finish()
        }
        more?.setOnClickListener {
            showSettingsBottomSheet()
        }
        rewind?.setOnClickListener {
            player?.seekTo(player!!.currentPosition - 10000)
        }
        forward?.setOnClickListener {
            player?.seekTo(player!!.currentPosition + 10000)
        }
        playPause?.setOnClickListener {
            if (player?.isPlaying == true) {
                player?.pause()
            } else {
                player?.play()
            }
        }
        episodesButton?.setOnClickListener {
            showEpisodesBottomSheet()
        }
        nextButton?.setOnClickListener {
            val currentSeasonMoviesSize = playerConfiguration!!.seasons[seasonIndex].movies.size

            if (seasonIndex < playerConfiguration!!.seasons.size) {
                if (episodeIndex < currentSeasonMoviesSize - 1) {
                    episodeIndex++
                } else {
                    episodeIndex = 0
                    seasonIndex++
                    selectedSeasonIndex = seasonIndex
                    currentSeason = playerConfiguration!!.seasons[seasonIndex]
                }
            }
            if (isLastEpisode()) {
                nextButton?.visibility = View.GONE
            } else {
                nextButton?.visibility = View.VISIBLE
            }
            title?.text =
                "S${seasonIndex + 1} E${episodeIndex + 1} " + playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title
            if (playerConfiguration!!.isMegogo && playerConfiguration!!.type == PlayerType.serial) {
                getMegogoStream()
            } else if (playerConfiguration!!.isPremier && playerConfiguration!!.type == PlayerType.serial) {
                getPremierStream()
            } else {
                val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                val hlsMediaSource: HlsMediaSource =
                    HlsMediaSource.Factory(dataSourceFactory)
                        .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
                player?.setMediaSource(hlsMediaSource)
                player?.prepare()
                player?.playWhenReady
            }
        }
        tvProgramsButton?.setOnClickListener {
            showTvProgramsBottomSheet()
        }
        zoom?.setOnClickListener {
            if (playerView?.resizeMode == AspectRatioFrameLayout.RESIZE_MODE_ZOOM)
                playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            else playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
        }
        orientation?.setOnClickListener {
            requestedOrientation =
                if (resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                    ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                } else {
                    ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                }
            it.postDelayed({
                requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
            }, 3000)
        }
    }


    private fun getMegogoStream() {
        retrofitService?.getMegogoStream(
            playerConfiguration!!.authorization,
            playerConfiguration!!.sessionId,
            playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].id,
            playerConfiguration!!.megogoAccessToken
        )?.enqueue(object : Callback<MegogoStreamResponse> {
            override fun onResponse(
                call: Call<MegogoStreamResponse>,
                response: Response<MegogoStreamResponse>
            ) {
                val body = response.body()
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    map[playerConfiguration!!.autoText] = body.data!!.src!!
                    body.data.bitrates?.forEach {
                        map["${it!!.bitrate}p"] = it.src!!
                    }
                    playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions =
                        map
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource =
                        HlsMediaSource.Factory(dataSourceFactory)
                            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
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

    private fun getPremierStream() {
        retrofitService?.getPremierStream(
            playerConfiguration!!.authorization,
            playerConfiguration!!.sessionId,
            playerConfiguration!!.videoId,
            playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].id,
        )?.enqueue(object : Callback<PremierStreamResponse> {
            override fun onResponse(
                call: Call<PremierStreamResponse>,
                response: Response<PremierStreamResponse>
            ) {
                val body = response.body()
                println(body.toString())
                if (body != null) {
                    val map: HashMap<String, String> = hashMapOf()
                    body.file_info?.forEach {
                        if (it!!.quality == "auto") {
                            map[playerConfiguration!!.autoText] = it.file_name!!
                        } else {
                            map[it.quality!!] = it.file_name!!
                        }
                    }
                    playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions =
                        map
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource =
                        HlsMediaSource.Factory(dataSourceFactory)
                            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
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

    private fun movieTrack() {
        var seasonKey = playerConfiguration!!.movieTrack.seasonKey
        var episodeKey = playerConfiguration!!.movieTrack.episodeKey
        if (playerConfiguration!!.type == PlayerType.serial) {
            seasonKey = "${seasonIndex + 1}"
            episodeKey = "${episodeIndex + 1}"
        }
        val copy = MovieTrack(
            seconds = player?.currentPosition?.div(1000)!!.toInt(),
            movieKey = playerConfiguration!!.movieTrack.movieKey,
            userId = playerConfiguration!!.movieTrack.userId,
            element = playerConfiguration!!.movieTrack.element,
            seasonKey = seasonKey,
            episodeKey = episodeKey,
            isMegogo = playerConfiguration!!.movieTrack.isMegogo,
        )
        retrofitService?.postMovieTrack(
            playerConfiguration!!.authorization,
            playerConfiguration!!.sessionId,
            copy,
        )?.enqueue(object : Callback<MovieTrackResponse> {
            override fun onResponse(
                call: Call<MovieTrackResponse>,
                response: Response<MovieTrackResponse>
            ) {
                response.body()
            }

            override fun onFailure(call: Call<MovieTrackResponse>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        println("newConfig.orientation: ${newConfig.orientation}")
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            setFullScreen()
            episodesText?.visibility = View.VISIBLE
            nextText?.visibility = View.VISIBLE
            if (playerConfiguration?.type == PlayerType.tv) {
                zoom?.visibility = View.VISIBLE
            }
            orientation?.setImageResource(R.drawable.ic_portrait)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
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
                BottomSheet.NONE -> {}
            }
        } else {
            cutFullScreen()
            zoom?.visibility = View.GONE
            episodesText?.visibility = View.GONE
            nextText?.visibility = View.GONE
            orientation?.setImageResource(R.drawable.ic_expand)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
                    backButtonEpisodeBottomSheet?.visibility = View.GONE
                }
                BottomSheet.SETTINGS -> {
                    backButtonSettingsBottomSheet?.visibility = View.GONE
                }
                BottomSheet.TV_PROGRAMS -> {

                }
                BottomSheet.QUALITY_OR_SPEED -> backButtonSettingsBottomSheet?.visibility =
                    View.GONE
                BottomSheet.NONE -> {}
            }
        }
    }

    private fun setFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        WindowInsetsControllerCompat(window, findViewById(R.id.exo_player_view)).let { controller ->
            controller.hide(WindowInsetsCompat.Type.systemBars())
            controller.systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }
    }

    private fun cutFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, true)
        WindowInsetsControllerCompat(window, findViewById(R.id.exo_player_view)).show(
            WindowInsetsCompat.Type.systemBars()
        )
    }

    private var currentBottomSheet = BottomSheet.NONE

    private fun showTvProgramsBottomSheet() {
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.behavior.maxHeight =
            (Resources.getSystem().displayMetrics.heightPixels - 96)
        bottomSheetDialog.behavior.peekHeight =
            (Resources.getSystem().displayMetrics.heightPixels - 96)
        bottomSheetDialog.setContentView(R.layout.tv_programs_sheet)
        val rv = bottomSheetDialog.findViewById<RecyclerView>(R.id.tv_programs_rv)
        val closeButtonTVBottomSheet =
            bottomSheetDialog.findViewById<ImageView>(R.id.close_button_tv_bottom_sheet)
        val titleTv = bottomSheetDialog.findViewById<TextView>(R.id.titleTV)
        closeButtonTVBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        titleTv?.text = playerConfiguration!!.programsInfoList.first().day
        val layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        rv?.layoutManager = layoutManager
        rv?.addItemDecoration(
            DividerItemDecoration(
                this@UdevsVideoPlayerActivity,
                LinearLayoutManager.VERTICAL
            )
        )
        rv?.adapter = TvProgramsRvAdapter(this, playerConfiguration!!.programsInfoList)
        bottomSheetDialog.show()
    }


    private var backButtonEpisodeBottomSheet: ImageView? = null
    private fun showEpisodesBottomSheet() {
        currentBottomSheet = BottomSheet.EPISODES
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.episodes)
        backButtonEpisodeBottomSheet =
            bottomSheetDialog.findViewById(R.id.episode_sheet_back)
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonEpisodeBottomSheet?.visibility = View.GONE
        } else {
            backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
        }
        backButtonEpisodeBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }

        val btnSeasons = bottomSheetDialog.findViewById<Button>(R.id.btn_seasons)
        val icClose = bottomSheetDialog.findViewById<ImageView>(R.id.ic_close_episodes)

        icClose?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }

        val rvEpisodes = bottomSheetDialog.findViewById<RecyclerView>(R.id.episodes_rv)

        rvEpisodesRvAdapter = EpisodesRvAdapter(
            this,
            object : EpisodesRvAdapter.OnClickListener {
                @SuppressLint("SetTextI18n")
                override fun onClick(index: Int) {
                    seasonIndex = selectedSeasonIndex
                    episodeIndex = index
                    title?.text = "S${seasonIndex + 1} E${episodeIndex + 1} " +
                            playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title
                    if (playerConfiguration!!.isMegogo && playerConfiguration!!.type == PlayerType.serial) {
                        getMegogoStream()
                    } else if (playerConfiguration!!.isPremier && playerConfiguration!!.type == PlayerType.serial) {
                        getPremierStream()
                    } else {
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
                        player?.setMediaSource(hlsMediaSource)
                        player?.prepare()
                        player?.playWhenReady
                    }


                    // check for the last episode in the "serial"
                    if (isLastEpisode()) {
                        nextButton?.visibility = View.GONE
                    } else {
                        nextButton?.visibility = View.VISIBLE
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        rvEpisodesRvAdapter.differ.submitList(currentSeason.movies)
        rvEpisodes?.adapter = rvEpisodesRvAdapter
        btnSeasons?.text = currentSeason.title
        btnSeasons?.setOnClickListener {
            showSeasonsBottomSheet(rvEpisodes, btnSeasons)
        }
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private fun isLastEpisode(): Boolean {
        return playerConfiguration!!.seasons.size == seasonIndex + 1 &&  playerConfiguration!!.seasons[playerConfiguration!!.seasons.size - 1].movies.size == episodeIndex + 1

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
        val bottomSheetDialog = BottomSheetDialog(this)
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
            playerConfiguration!!.qualityText
        bottomSheetDialog.findViewById<TextView>(R.id.speed_settings_text)?.text =
            playerConfiguration!!.speedText
        qualityText = bottomSheetDialog.findViewById(R.id.quality_settings_value_text)
        speedText = bottomSheetDialog.findViewById(R.id.speed_settings_value_text)
        qualityText?.text = currentQuality
        speedText?.text = currentSpeed
        quality?.setOnClickListener {
            tvQualitiesList = if (playerConfiguration!!.type == PlayerType.serial) {
                playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions.keys.toList()
            } else {
                playerConfiguration?.resolutions?.keys?.toList() as List
            }


            showQualitySpeedSheet(
                currentQuality,
                tvQualitiesList,
                true,
            )
        }
        speed?.setOnClickListener {
            showQualitySpeedSheet(currentSpeed, speeds as ArrayList, false)
        }
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private fun showSeasonsBottomSheet(rvEpisodes: RecyclerView?, btnSeasons: Button) {
        val seasonsBottomSheetDialog = BottomSheetDialog(this)
        seasonsBottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        seasonsBottomSheetDialog.setContentView(R.layout.seasons_page)
        val rv_seasons = seasonsBottomSheetDialog.findViewById<RecyclerView>(R.id.rv_seasons)
        val cv_close = seasonsBottomSheetDialog.findViewById<ConstraintLayout>(R.id.cv_close)
        val tv_close = seasonsBottomSheetDialog.findViewById<TextView>(R.id.tv_close)

        tv_close?.text = playerConfiguration?.closeText

        rv_seasons?.adapter = SeasonsRvAdapter(
            this,
            playerConfiguration!!.seasons,
            object : SeasonsRvAdapter.OnClickListener {
                override fun onClick(seasonPosition: Int) {
                    selectedSeasonIndex = seasonPosition
                    currentSeason = playerConfiguration!!.seasons[seasonPosition]
                    btnSeasons.text = currentSeason.title
                    rvEpisodesRvAdapter.notifyDataSetChanged()
                    rvEpisodesRvAdapter.differ.submitList(currentSeason.movies)
                    seasonsBottomSheetDialog.dismiss()
                }

            }, selectedSeasonIndex
        )



        cv_close?.setOnClickListener {
            seasonsBottomSheetDialog.dismiss()
        }

        seasonsBottomSheetDialog.show()
    }

    private var backButtonQualitySpeedBottomSheet: ImageView? = null
    private fun showQualitySpeedSheet(
        initialValue: String,
        list: List<String>,
        fromQuality: Boolean
    ) {
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this)
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
        val title = if (fromQuality) {
            playerConfiguration!!.qualityText
        } else {
            playerConfiguration!!.speedText
        }
        bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text = title
        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView
        //sorting
        val l = mutableListOf<String>()
        var auto = ""
        list.forEach {
            if (it.substring(0, it.length - 1).toIntOrNull() != null) {
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
                        0,
                        second.length - 1
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
        val data = if (fromQuality) {
            l as List<String>
        } else {
            list
        }
        val adapter = QualitySpeedAdapter(
            initialValue,
            this,
            data,
            object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        currentQuality = l[position]
                        qualityText?.text = currentQuality
                        if (player?.isPlaying == true) {
                            player?.pause()
                        }
                        val currentPosition = player?.currentPosition
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()

                        val uri = if (playerConfiguration!!.type == PlayerType.serial) {
                            Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])
                        } else {
                            Uri.parse(playerConfiguration!!.resolutions[currentQuality])
                        }
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(uri))
                        player?.setMediaSource(hlsMediaSource)
                        player?.seekTo(currentPosition!!)
                        player?.prepare()
                        player?.playWhenReady
                    } else {
                        currentSpeed = list[position]
                        speedText?.text = currentSpeed
                        player?.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            }
        )
        listView.adapter = adapter
        bottomSheetDialog.show()

        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
        }
    }

    override fun onDown(p0: MotionEvent?): Boolean = false
    override fun onShowPress(p0: MotionEvent?) = Unit

    private var lastClicked: Long = -1L
    override fun onSingleTapUp(event: MotionEvent?): Boolean {
        lastClicked = if (lastClicked == -1L) {
            System.currentTimeMillis()
        } else {
            if (isDoubleClicked(lastClicked)) {
                if (playerConfiguration!!.type != PlayerType.tv) {
                    if (event!!.x < sWidth / 2) {
                        player?.seekTo(player!!.currentPosition - 10000)
                    } else {
                        player?.seekTo(player!!.currentPosition + 10000)
                    }
                }
            } else {
                playerView?.showController()
            }
            -1L
        }
        Handler(Looper.getMainLooper()).postDelayed({
            if (lastClicked != -1L) {
                playerView?.showController()
                lastClicked = -1L
            }
        }, 300)
        return false
    }

    private fun isDoubleClicked(lastClicked: Long): Boolean =
        lastClicked - System.currentTimeMillis() <= 300

    override fun onLongPress(p0: MotionEvent?) = Unit
    override fun onFling(p0: MotionEvent?, p1: MotionEvent?, p2: Float, p3: Float): Boolean = false

    override fun onScroll(
        event: MotionEvent?,
        event1: MotionEvent?,
        distanceX: Float,
        distanceY: Float
    ): Boolean {
        if (abs(distanceX) < abs(distanceY)) {
            if (event!!.x < sWidth / 2) {
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
    override fun onScale(detector: ScaleGestureDetector?): Boolean {
        scaleFactor = detector?.scaleFactor!!
        return true
    }

    override fun onScaleBegin(p0: ScaleGestureDetector?): Boolean {
        return true
    }

    override fun onScaleEnd(p0: ScaleGestureDetector?) {
        if (scaleFactor > 1) {
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
        } else {
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
        }
    }
}