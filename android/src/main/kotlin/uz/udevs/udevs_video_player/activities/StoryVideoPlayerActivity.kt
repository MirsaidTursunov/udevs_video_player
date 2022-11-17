package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.res.Resources
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.*
import android.widget.*
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.PlayerView
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.*
import uz.udevs.udevs_video_player.retrofit.Common
import uz.udevs.udevs_video_player.retrofit.RetrofitService
import kotlin.math.abs

class StoryVideoPlayerActivity : Activity(),
    ScaleGestureDetector.OnScaleGestureListener, GestureDetector.OnGestureListener {
    private var retrofitService: RetrofitService? = null
    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var progressbar: ProgressBar? = null
    private var progressbar2: ProgressBar? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var storiesProgressView: ProgressBar? = null
    private var progressBarStatus = 0
    private var max = 0
    private var sWidth: Int = 0
    private var storyIndex: Int = 0
    private lateinit var btnClose: View
    private lateinit var btnWatchMovie: View
    private lateinit var storyContainer: View
    private lateinit var gestureDetector: GestureDetector

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
        retrofitService = Common.retrofitService(playerConfiguration!!.baseUrl)
//        retrofitService = Common.retrofitService("https://api.spec.sharqtv.udevs.io/v1/")
        storyIndex = playerConfiguration!!.storyIndex
        playerView = findViewById(R.id.story_player_view)
        storyContainer = findViewById(R.id.story_container)
        storiesProgressView = findViewById<View>(R.id.stories) as ProgressBar
        progressbar = findViewById<View>(R.id.video_progress_bar_story) as ProgressBar
        progressbar2 = findViewById<View>(R.id.video_progress_bar_story2) as ProgressBar
        btnClose = findViewById(R.id.cv_story_close)
        btnWatchMovie = findViewById(R.id.btn_story_movie)
        sWidth = Resources.getSystem().displayMetrics.widthPixels

        gestureDetector = GestureDetector(this, this)
        storyContainer.setOnTouchListener { _, motionEvent ->
            gestureDetector.onTouchEvent(motionEvent)
            return@setOnTouchListener true
        }

        btnClose.setOnClickListener { // inside on click we are
            onBackPressed()
        }
        val storyMovieText = findViewById<TextView>(R.id.tv_play)
        storyMovieText.text = playerConfiguration?.storyButtonText
        btnWatchMovie.setOnClickListener { // inside on click we are
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

        mFinishActivity()
    }

    private fun mFinishActivity() {
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
            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.story[storyIndex].fileName)))
        progressBarStatus = 0
        max = playerConfiguration!!.story[storyIndex].duration.toInt() * 1000
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
                        println("Before requesting for check analtyics api")
                        checkAnalytics(storyIndex)
//                        if (max != player!!.duration.toInt() * 1000) {
//                            max = player!!.duration.toInt()
//                        }
                        storiesProgressView?.max = max
                        storiesProgressView?.progress = progressBarStatus
                        playerView?.postDelayed({ getCurrentPlayerPosition() }, 100)

                    }
                }

                override fun onPlaybackStateChanged(playbackState: Int) {
                    when (playbackState) {
                        Player.STATE_BUFFERING -> {
                            progressbar?.visibility = View.VISIBLE
                            if (playerView?.isControllerFullyVisible == false) {
                                if (progressbar?.visibility == View.GONE) {
                                    progressbar2?.visibility = View.VISIBLE
                                }
                            }
                        }
                        Player.STATE_READY -> {
                            progressbar?.visibility = View.GONE
                            if (playerView?.isControllerFullyVisible == false) {
                                progressbar2?.visibility = View.GONE
                            }
                        }
                        Player.STATE_ENDED -> {
                            if (playerConfiguration!!.story.size > storyIndex + 1) {
                                storyIndex++
                                playStory(storyIndex)
                            } else {
                                backPressed()
                            }
                        }
                        Player.STATE_IDLE -> {}
                    }
                }

                private fun getCurrentPlayerPosition() {
                    storiesProgressView?.progress = player!!.currentPosition.toInt()
                    if (player!!.isPlaying) {
                        playerView!!.postDelayed({ getCurrentPlayerPosition() }, 100)
                    }
                }
            })
        player?.playWhenReady = true
    }

    private fun playStory(index: Int) {
        progressBarStatus = 0
        max = playerConfiguration!!.story[index].duration.toInt() * 1000
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

    private fun checkAnalytics(index: Int) {
        if (playerConfiguration!!.userId.isEmpty()) return
        if (playerConfiguration!!.story[index].isWatched) return
        println("Check analtyics method called")
        println("story item file name : ${playerConfiguration!!.story[index].slug}")
        println("${playerConfiguration!!.story[index].fileName} *** ${playerConfiguration!!.userId} *** ${playerConfiguration!!.story[index].isAmediateka}")
        val analytics = CheckAnalyticsRequest(
            episodeKey = "0",
            isStory = true,
            movieKey = playerConfiguration!!.story[index].slug,
            seasonKey = "0",
            userId = playerConfiguration!!.userId,
            videoPlatform = if (playerConfiguration!!.story[index].isAmediateka) "AMEDIATEKA" else "SHARQ",
        )
        retrofitService?.postStoryAnalytics(
            playerConfiguration!!.authorization,
            playerConfiguration!!.sessionId,
            analytics,
        )?.enqueue(object : Callback<CheckAnalyticsResponse> {
            override fun onResponse(
                call: Call<CheckAnalyticsResponse>,
                response: Response<CheckAnalyticsResponse>
            ) {
                if (response.isSuccessful) {
                    println("CheckAnalyticsResponse successful")
                }

            }

            override fun onFailure(call: Call<CheckAnalyticsResponse>, t: Throwable) {
                println("Request for check analtyics api is failed")
                t.printStackTrace()
            }
        })
    }

    override fun onScale(detector: ScaleGestureDetector?): Boolean = false

    override fun onScaleBegin(detector: ScaleGestureDetector?): Boolean = false

    override fun onScaleEnd(detector: ScaleGestureDetector?) {}

    override fun onDown(p0: MotionEvent?): Boolean = false

    override fun onShowPress(p0: MotionEvent?) {}

    override fun onSingleTapUp(event: MotionEvent?): Boolean {
        if (event!!.x < sWidth / 2) {
            reverse()
        } else {
            skip()
        }
        return true
    }

    override fun onScroll(p0: MotionEvent?, p1: MotionEvent?, p2: Float, p3: Float): Boolean = false

    override fun onLongPress(p0: MotionEvent?) {
    }

    override fun onFling(
        downEvent: MotionEvent?,
        moveEvent: MotionEvent?,
        velocityX: Float,
        velocityY: Float
    ): Boolean {
        var result = false
        val diffY = moveEvent!!.y - downEvent!!.y
        val diffX = moveEvent.x - downEvent.x
//        which was greater? movement across Y or X?]
        if (abs(diffX) > abs(diffY)) {
//            right or left swipe
            if (abs(diffX) > 100 && abs(velocityX) > 100) {
                if (diffX > 0) {
                    onSwipeRight()
                } else {
                    onSwipeLeft()

                }
                result = true
            }
        } else {
//             up or down swipe
            if (abs(diffY) > 100 && abs(velocityY) > 100) {
                if (diffY > 0) {
                    onSwipeBottom()
                } else {
                    onSwipeTop()
                }
                result = true
            }
        }

        return result
    }

    private fun onSwipeTop() {
        mFinishActivity()
    }

    private fun onSwipeBottom() {}

    private fun onSwipeLeft() {}

    private fun onSwipeRight() {}
}

