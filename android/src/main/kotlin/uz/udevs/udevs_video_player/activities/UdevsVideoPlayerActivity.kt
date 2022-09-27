package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
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
import androidx.media3.ui.PlayerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.adapters.QualitySpeedAdapter
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class UdevsVideoPlayerActivity : Activity() {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var title: TextView? = null
    private var subtitle: TextView? = null
    private var playPause: ImageView? = null
    private var timer: LinearLayout? = null
    private var qualityButton: Button? = null
    private var speedButton: Button? = null
    private var previousButton: ImageButton? = null
    private var nextButton: ImageButton? = null
    private var seasonIndex: Int = 0
    private var episodeIndex: Int = 0

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player_activity)
        actionBar?.hide()
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?
        seasonIndex = playerConfiguration!!.seasonIndex
        episodeIndex = playerConfiguration!!.episodeIndex
        currentQuality = playerConfiguration?.initialResolution?.keys?.first()!!

        playerView = findViewById(R.id.exo_player_view)

        title = findViewById(R.id.video_title)
        subtitle = findViewById(R.id.video_subtitle)
        title?.text = playerConfiguration?.title

        playPause = findViewById(R.id.video_play_pause)
        timer = findViewById(R.id.timer)
        if (playerConfiguration?.isLive == true) {
            timer?.visibility = View.GONE
        }
        qualityButton = findViewById(R.id.quality_button)
        speedButton = findViewById(R.id.speed_button)

        previousButton = findViewById(R.id.video_previous)
        nextButton = findViewById(R.id.video_next)
        if (playerConfiguration?.isSerial == true) {
            previousButton?.visibility = View.VISIBLE
            nextButton?.visibility = View.VISIBLE
        }

        initializeClickListeners()

        if (playerConfiguration?.playVideoFromAsset == true) {
            playFromAsset()
        } else {
            playVideo()
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
                        playPause?.setImageResource(R.drawable.ic_pause)
                    } else {
                        playPause?.setImageResource(R.drawable.ic_play)
                    }
                    Handler(Looper.getMainLooper()).postDelayed({
                    }, 300)
                }
            })
        player?.playWhenReady = true
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
        qualityButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                qualityButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                qualityButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        speedButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                speedButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                speedButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        previousButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                previousButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                previousButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        nextButton?.setOnFocusChangeListener { _, b ->
            if (b) {
                nextButton?.setBackgroundResource(R.drawable.focus_background)
            } else {
                nextButton?.setBackgroundColor(Color.parseColor("#00FFFFFF"))
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
            if (seasonIndex < playerConfiguration!!.seasons.size) {
                if (episodeIndex < playerConfiguration!!.seasons[seasonIndex].movies.size - 1) {
                    episodeIndex++
                } else {
                    seasonIndex++
                }
            }
            if (seasonIndex == playerConfiguration!!.seasons.size - 1 &&
                episodeIndex == playerConfiguration!!.seasons[seasonIndex].movies.size - 1
            ) {
                nextButton?.visibility = View.GONE
            }
            title?.text =
                "S${seasonIndex + 1} E${episodeIndex + 1} " +
                        playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title
            val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
            val hlsMediaSource: HlsMediaSource =
                HlsMediaSource.Factory(dataSourceFactory)
                    .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
            player?.setMediaSource(hlsMediaSource)
            player?.prepare()
            player?.playWhenReady
        }
        nextButton?.setOnClickListener {
            if (seasonIndex < playerConfiguration!!.seasons.size) {
                if (episodeIndex < playerConfiguration!!.seasons[seasonIndex].movies.size - 1) {
                    episodeIndex++
                } else {
                    seasonIndex++
                }
            }
            if (seasonIndex == playerConfiguration!!.seasons.size - 1 &&
                episodeIndex == playerConfiguration!!.seasons[seasonIndex].movies.size - 1
            ) {
                nextButton?.visibility = View.GONE
            }
            title?.text =
                "S${seasonIndex + 1} E${episodeIndex + 1} " +
                        playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title
            val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
            val hlsMediaSource: HlsMediaSource =
                HlsMediaSource.Factory(dataSourceFactory)
                    .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
            player?.setMediaSource(hlsMediaSource)
            player?.prepare()
            player?.playWhenReady
        }
    }

    private var speeds =
        mutableListOf("0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x")
    private var currentQuality = ""
    private var currentSpeed = "1.0x"
    private var qualityText: TextView? = null
    private var speedText: TextView? = null

    private var backButtonQualitySpeedBottomSheet: ImageView? = null
    private fun showQualitySpeedSheet(
        initialValue: String,
        list: ArrayList<String>,
        fromQuality: Boolean
    ) {
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
        bottomSheetDialog.findViewById<TextView>(R.id.quality_speed_text)?.text =
            playerConfiguration!!.qualityText
        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView
        val adapter = QualitySpeedAdapter(
            initialValue,
            this,
            list, (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        currentQuality = list[position]
                        qualityText?.text = currentQuality
                        if (player?.isPlaying == true) {
                            player?.pause()
                        }
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
                        currentSpeed = list[position]
                        speedText?.text = currentSpeed
                        player?.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
    }
}