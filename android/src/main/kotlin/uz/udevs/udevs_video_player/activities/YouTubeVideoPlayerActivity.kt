package uz.udevs.udevs_video_player.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ProcessLifecycleOwner
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.options.IFramePlayerOptions
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class YouTubeVideoPlayerActivity : Activity(), LifecycleObserver {

    private var playerConfiguration: PlayerConfiguration? = null
    private lateinit var youTubePlayerView: YouTubePlayerView
    private lateinit var kYouTubePlayer: YouTubePlayer
    private var isPlaying: Boolean = true


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.youtube_activity)
        actionBar?.hide()
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?

        youTubePlayerView = findViewById(R.id.youtube_player_view)
        ProcessLifecycleOwner.get().lifecycle.addObserver(youTubePlayerView)
        youTubePlayerView.isFocusable = true

        val iFramePlayerOptions: IFramePlayerOptions = IFramePlayerOptions.Builder()
            .controls(0)
            .autoplay(1)
            .ivLoadPolicy(3)
            .fullscreen(1)
            .build()
        youTubePlayerView.initialize(object : AbstractYouTubePlayerListener() {
            override fun onReady(youTubePlayer: YouTubePlayer) {
                val videoId = playerConfiguration!!.videoId
                kYouTubePlayer = youTubePlayer
                youTubePlayer.loadVideo(videoId, 0f)
                youTubePlayer.play()
            }

        }, false, iFramePlayerOptions)
    }


    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        when (keyCode) {
            KeyEvent.KEYCODE_DPAD_CENTER -> {
                print("KEYCODE_DPAD_CENTER")
                if (isPlaying) {
                    kYouTubePlayer.pause()
                } else {
                    kYouTubePlayer.play()
                }
                isPlaying = !isPlaying
                return true
            }

            KeyEvent.KEYCODE_BACK -> {
                finish()
                return true
            }
        }
        return false
    }

    override fun onDestroy() {
        super.onDestroy()
        youTubePlayerView.release()
    }

}