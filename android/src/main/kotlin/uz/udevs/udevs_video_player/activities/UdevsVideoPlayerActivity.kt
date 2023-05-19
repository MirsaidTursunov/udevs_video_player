package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.res.Resources
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.KeyEvent
import android.view.View
import android.widget.*
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
import uz.udevs.udevs_video_player.adapters.QualitySpeedAdapter
import uz.udevs.udevs_video_player.adapters.TvProgramsRvAdapter
import uz.udevs.udevs_video_player.models.CurrentFocus
import uz.udevs.udevs_video_player.models.MegogoStreamResponse
import uz.udevs.udevs_video_player.models.PlayerConfiguration
import uz.udevs.udevs_video_player.models.PremierStreamResponse
import uz.udevs.udevs_video_player.retrofit.Common
import uz.udevs.udevs_video_player.retrofit.RetrofitService
import java.security.SecureRandom
import java.security.cert.CertificateException
import java.security.cert.X509Certificate
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.X509TrustManager

class UdevsVideoPlayerActivity : Activity() {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var title: TextView? = null
    private var subtitle: TextView? = null
    private var playPause: ImageView? = null
    private var exoProgress: DefaultTimeBar? = null
    private var customSeekBar: SeekBar? = null
    private var timer: LinearLayout? = null
    private var live: LinearLayout? = null
    private var qualityButton: Button? = null
    private var speedButton: Button? = null
    private var tvButton: Button? = null
    private var previousButton: ImageButton? = null
    private var nextButton: ImageButton? = null
    private var seasonIndex: Int = 0
    private var episodeIndex: Int = 0
    private var currentFocus = CurrentFocus.NONE
    private var retrofitService: RetrofitService? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player_activity)
        actionBar?.hide()
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?
        seasonIndex = playerConfiguration!!.seasonIndex
        episodeIndex = playerConfiguration!!.episodeIndex
        currentQuality = playerConfiguration?.initialResolution?.keys?.first()!!

        playerView = findViewById(R.id.exo_player_view)

        initializeViews()
        retrofitService = Common.retrofitService(playerConfiguration!!.baseUrl)
        initializeClickListeners()

        trustEveryone()
        if (playerConfiguration?.playVideoFromAsset == true) {
            playFromAsset()
        } else {
            playVideo()
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        when (keyCode) {
            KeyEvent.KEYCODE_DPAD_CENTER -> {
                if (currentFocus == CurrentFocus.EXO_PROGRESS) {
                    playPause?.visibility = View.VISIBLE
                    Handler(Looper.getMainLooper()).postDelayed({
                        playPause?.visibility = View.GONE
                    }, 1000)
                    if (player?.isPlaying == true) {
                        player?.pause()
                        playPause?.setImageResource(R.drawable.ic_pause)
                    } else {
                        player?.play()
                        playPause?.setImageResource(R.drawable.ic_play)
                    }
                }
                return true
            }
            KeyEvent.KEYCODE_BACK -> {
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
                return true
            }
        }
        return false
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
        finish()
        super.onBackPressed()
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

    override fun onPause() {
        super.onPause()
        player?.playWhenReady = false
    }

    override fun onResume() {
        super.onResume()
        player?.playWhenReady = true
    }

    override fun onRestart() {
        super.onRestart()
        player?.playWhenReady = true
    }

    private fun playFromAsset() {
        val uri =
            Uri.parse("asset:///flutter_assets/${playerConfiguration!!.assetPath}")
        val dataSourceFactory: DataSource.Factory = DefaultDataSource.Factory(this)
        val mediaSource: MediaSource = ProgressiveMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(uri))
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = false
        playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
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
        playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
        player?.setMediaSource(hlsMediaSource)
        player?.seekTo(playerConfiguration!!.lastPosition * 1000)
        player?.prepare()
        player?.addListener(
            object : Player.Listener {
                override fun onPlayerError(error: PlaybackException) {
                    println(error.errorCode)
                }
            })
        player?.playWhenReady = true
    }

    @SuppressLint("SetTextI18n")
    private fun initializeViews() {
        title = findViewById(R.id.video_title)
        subtitle = findViewById(R.id.video_subtitle)
        title?.text = playerConfiguration?.title

        timer = findViewById(R.id.timer)
        live = findViewById(R.id.live)
        playPause = findViewById(R.id.video_play_pause)
        exoProgress = findViewById(R.id.exo_progress)
        exoProgress?.setKeyTimeIncrement(15000)
        customSeekBar = findViewById(R.id.progress_bar)
        customSeekBar?.isEnabled = false
        qualityButton = findViewById(R.id.quality_button)
        qualityButton?.text = playerConfiguration!!.qualityText
        speedButton = findViewById(R.id.speed_button)
        speedButton?.text = playerConfiguration!!.speedText
        tvButton = findViewById(R.id.tv_button)
        tvButton?.text=playerConfiguration!!.programsText
        previousButton = findViewById(R.id.video_previous)
        nextButton = findViewById(R.id.video_next)
        if (playerConfiguration?.isSerial == true && !(seasonIndex == playerConfiguration!!.seasons.size - 1 &&
                    episodeIndex == playerConfiguration!!.seasons[seasonIndex].movies.size - 1)
        ) {
            nextButton?.visibility = View.VISIBLE
        }
        if (playerConfiguration?.isSerial == true && (seasonIndex == 0 && episodeIndex != 0 || seasonIndex > 0)) {
            previousButton?.visibility = View.VISIBLE
        }
        if (playerConfiguration?.isSerial == true) {
            subtitle?.visibility = View.VISIBLE
            subtitle?.text =
                "${seasonIndex + 1} ${playerConfiguration!!.seasonText}, ${episodeIndex + 1} ${playerConfiguration!!.episodeText}"
        }
        if (playerConfiguration?.isLive == true) {
            live?.visibility = View.VISIBLE
            timer?.visibility = View.GONE
            exoProgress?.visibility = View.GONE
            customSeekBar?.visibility = View.VISIBLE
            tvButton?.visibility = View.VISIBLE
        }
    }

    @SuppressLint("SetTextI18n", "ClickableViewAccessibility")
    private fun initializeClickListeners() {
        playPause?.setOnClickListener {
            if (player?.isPlaying == true) {
                player?.pause()
            } else {
                player?.play()
            }
        }
        exoProgress?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.EXO_PROGRESS
            }
        }
        qualityButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.QUALITY
                qualityButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                qualityButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        speedButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.SPEED
                speedButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                speedButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        previousButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.PREVIOUS_BTN
                previousButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                previousButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        nextButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.NEXT_BTN
                nextButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                nextButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        tvButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                currentFocus = CurrentFocus.TV_BTN
                tvButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                tvButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        qualityButton?.setOnClickListener {
            showQualitySpeedSheet(
                currentQuality,
                playerConfiguration?.resolutions?.keys?.toList() as ArrayList,
                true,
            )
        }
        speedButton?.setOnClickListener {
            showQualitySpeedSheet(currentSpeed, speeds as ArrayList, false)
        }
        previousButton?.setOnClickListener {
            if (episodeIndex > 0) {
                episodeIndex--
            } else {
                seasonIndex--
                episodeIndex = playerConfiguration!!.seasons[seasonIndex].movies.size - 1
            }
            nextButton?.visibility = View.VISIBLE
            if (seasonIndex == 0 && episodeIndex == 0
            ) {
                previousButton?.visibility = View.INVISIBLE
            }
            subtitle?.text =
                "${seasonIndex + 1} ${playerConfiguration!!.seasonText}, ${episodeIndex + 1} ${playerConfiguration!!.episodeText}"
            if (playerConfiguration!!.isMegogo && playerConfiguration!!.isSerial) {
                getMegogoStream()
            } else if (playerConfiguration!!.isPremier && playerConfiguration!!.isSerial) {
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
        nextButton?.setOnClickListener {
            if (seasonIndex < playerConfiguration!!.seasons.size) {
                if (episodeIndex < playerConfiguration!!.seasons[seasonIndex].movies.size - 1) {
                    episodeIndex++
                } else {
                    seasonIndex++
                }
            }
            previousButton?.visibility = View.VISIBLE
            if (seasonIndex == playerConfiguration!!.seasons.size - 1 &&
                episodeIndex == playerConfiguration!!.seasons[seasonIndex].movies.size - 1
            ) {
                nextButton?.visibility = View.INVISIBLE
            }
            subtitle?.text =
                "${seasonIndex + 1} ${playerConfiguration!!.seasonText}, ${episodeIndex + 1} ${playerConfiguration!!.episodeText}"
            if (playerConfiguration!!.isMegogo && playerConfiguration!!.isSerial) {
                getMegogoStream()
            } else if (playerConfiguration!!.isPremier && playerConfiguration!!.isSerial) {
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
        tvButton?.setOnClickListener {
            showTvProgramsBottomSheet()
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

    private var speeds =
        mutableListOf("0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x")
    private var currentQuality = ""
    private var currentSpeed = "1.0x"
    private var qualityText: TextView? = null
    private var speedText: TextView? = null

    private fun showQualitySpeedSheet(
        initialValue: String,
        list: ArrayList<String>,
        fromQuality: Boolean
    ) {
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.quality_speed_sheet)
        if (fromQuality) {
            bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
                playerConfiguration!!.qualityText
        } else {
            bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
                playerConfiguration!!.speedText
        }
        val recyclerView =
            bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as RecyclerView
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        //sorting
        val l = mutableListOf<String>()
        if (fromQuality) {
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
        } else {
            l.addAll(list)
        }
        val adapter = QualitySpeedAdapter(
            initialValue,
            l as ArrayList<String>, (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        currentQuality = l[position]
                        qualityText?.text = currentQuality
                        val currentPosition = player?.currentPosition
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.resolutions[currentQuality])))
                        player?.setMediaSource(hlsMediaSource)
                        player?.seekTo(currentPosition!!)
                        player?.prepare()
                        player?.playWhenReady
                    } else {
                        currentSpeed = l[position]
                        speedText?.text = currentSpeed
                        player?.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        )
        recyclerView.adapter = adapter
        bottomSheetDialog.show()
    }

    private fun showTvProgramsBottomSheet() {
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.isDraggable = false
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.behavior.peekHeight = Resources.getSystem().displayMetrics.heightPixels
        bottomSheetDialog.setContentView(R.layout.tv_programs_sheet)
        val rv = bottomSheetDialog.findViewById<RecyclerView>(R.id.tv_programs_rv)
        val layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        rv?.layoutManager = layoutManager
        rv?.adapter = TvProgramsRvAdapter(playerConfiguration!!.programsInfoList)
        bottomSheetDialog.show()
    }
}