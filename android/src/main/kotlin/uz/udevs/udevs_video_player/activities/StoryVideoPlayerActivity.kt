package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.res.Resources
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.*
import android.widget.Button
import android.widget.ImageView
import android.widget.ProgressBar
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.PlayerView
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class StoryVideoPlayerActivity : Activity(), GestureDetector.OnGestureListener,
    ScaleGestureDetector.OnScaleGestureListener {
    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var storiesProgressView: ProgressBar? = null
    private var progressBarStatus = 0
    private var max = 0
    private var sWidth: Int = 0
    private var storyIndex: Int = 0

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.story_player_activity)
        actionBar?.hide()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val window = window
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            window.statusBarColor = Color.BLACK
            window.navigationBarColor = Color.BLACK
        }
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?

        playerView = findViewById(R.id.story_player_view)
        storiesProgressView = findViewById<View>(R.id.stories) as ProgressBar
        sWidth = Resources.getSystem().displayMetrics.widthPixels

        /// gesture detector
        val reverse = findViewById<View>(R.id.reverse)
        reverse.setOnClickListener { // inside on click we are
            reverse()
        }

        val skip = findViewById<View>(R.id.skip)
        skip.setOnClickListener { // inside on click we are
            skip()
        }
        val close = findViewById<ImageView>(R.id.story_close)
        close.setOnClickListener { // inside on click we are
            onBackPressed()
        }
        val storyMovie = findViewById<Button>(R.id.story_movie)
        storyMovie.setOnClickListener { // inside on click we are
            backPressed()
        }
        /// play video
        playVideo()
    }

    override fun onBackPressed() {
        if (player?.isPlaying == true) {
            player?.stop()
        }
        val intent = Intent()
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

    private fun backPressed() {
        if (player?.isPlaying == true) {
            player?.stop()
        }
        val intent = Intent()
        intent.putExtra("slug", playerConfiguration!!.story[storyIndex].slug)
        intent.putExtra("title", playerConfiguration!!.story[storyIndex].title)
        setResult(PLAYER_ACTIVITY_FINISH, intent)
        finish()
    }

    private fun skip() {
        if (playerConfiguration!!.story.size > storyIndex + 1) {
            storyIndex++
            playStory(storyIndex)
        } else {
            backPressed()
        }
    }

    private fun reverse() {
        if (storyIndex > 0) {
            storyIndex--
            playStory(storyIndex)
        }
    }

    private fun playVideo() {
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.story.first().fileName)))
        progressBarStatus = 0
        max = playerConfiguration!!.story.first().duration.toInt()
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
                    Thread(Runnable {
                        while (progressBarStatus <= max) {
                            try {
                                progressBarStatus += 1
                                Thread.sleep(1000)
                            } catch (e: InterruptedException) {
                                e.printStackTrace()
                            }
                            val num = progressBarStatus.toDouble() * 100 / (max.toDouble())
                            storiesProgressView?.progress =
                                num.toInt()
                        }
                    }).start()
                }

                override fun onPlaybackStateChanged(playbackState: Int) {
                    when (playbackState) {
                        Player.STATE_BUFFERING -> {
                            if (playerView?.isControllerFullyVisible == false) {
                                playerView?.setShowBuffering(PlayerView.SHOW_BUFFERING_ALWAYS)
                            }
                        }
                        Player.STATE_READY -> {
                            if (playerView?.isControllerFullyVisible == false) {
                                playerView?.setShowBuffering(PlayerView.SHOW_BUFFERING_NEVER)
                            }
                        }
                        Player.STATE_ENDED -> {
                            skip()
                        }
                        Player.STATE_IDLE -> {}
                    }
                }
            })
        player?.playWhenReady = true
    }

    private fun playStory(index: Int) {
        progressBarStatus = 0
        max = playerConfiguration!!.story[index].duration.toInt()
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource =
            HlsMediaSource.Factory(dataSourceFactory)
                .createMediaSource(
                    MediaItem.fromUri(
                        Uri.parse(
                            playerConfiguration!!.story[index].fileName
                        )
                    )
                )
        player?.setMediaSource(hlsMediaSource)
        player?.prepare()
        player?.playWhenReady = true
    }


    override fun onDown(e: MotionEvent?): Boolean {
        TODO("Not yet implemented")
    }

    override fun onShowPress(e: MotionEvent?) {
        TODO("Not yet implemented")
    }

    override fun onSingleTapUp(e: MotionEvent?): Boolean {
        return false
    }

    override fun onScroll(
        e1: MotionEvent?,
        e2: MotionEvent?,
        distanceX: Float,
        distanceY: Float
    ): Boolean {
        TODO("Not yet implemented")
    }

    override fun onLongPress(e: MotionEvent?) {
        TODO("Not yet implemented")
    }

    override fun onFling(
        e1: MotionEvent?,
        e2: MotionEvent?,
        velocityX: Float,
        velocityY: Float
    ): Boolean {
        TODO("Not yet implemented")
    }

    override fun onScale(detector: ScaleGestureDetector?): Boolean {
        TODO("Not yet implemented")
    }

    override fun onScaleBegin(detector: ScaleGestureDetector?): Boolean {
        TODO("Not yet implemented")
    }

    override fun onScaleEnd(detector: ScaleGestureDetector?) {
        TODO("Not yet implemented")
    }
}