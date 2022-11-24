package uz.udevs.udevs_video_player

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.media3.common.MediaItem
import androidx.media3.common.MediaMetadata
import androidx.media3.common.util.Util
import androidx.media3.exoplayer.RenderersFactory
import androidx.media3.exoplayer.offline.Download
import androidx.media3.exoplayer.offline.DownloadService
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import uz.udevs.udevs_video_player.activities.UdevsVideoPlayerActivity
import uz.udevs.udevs_video_player.models.DownloadConfiguration
import uz.udevs.udevs_video_player.models.PlayerConfiguration
import uz.udevs.udevs_video_player.services.DownloadTracker
import uz.udevs.udevs_video_player.services.DownloadUtil
import uz.udevs.udevs_video_player.services.MyDownloadService
import kotlin.math.roundToInt

const val EXTRA_ARGUMENT = "uz.udevs.udevs_video_player.ARGUMENT"
const val PLAYER_ACTIVITY = 111
const val PLAYER_ACTIVITY_FINISH = 222

class UdevsVideoPlayerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener, PluginRegistry.ActivityResultListener,
    DownloadTracker.Listener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var resultMethod: Result? = null
    private var downloadTracker: DownloadTracker? = null
    lateinit var renderersFactory: RenderersFactory
    val gson = Gson()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "udevs_video_player")
        channel.setMethodCallHandler(this)
        downloadTracker = DownloadUtil.getDownloadTracker(flutterPluginBinding.applicationContext)
        startDownloadService(flutterPluginBinding.applicationContext)
        downloadTracker!!.addListener(this)
        renderersFactory =
            DownloadUtil.buildRenderersFactory(flutterPluginBinding.applicationContext, false)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "playVideo") {
            if (call.hasArgument("playerConfigJsonString")) {
                val playerConfigJsonString = call.argument("playerConfigJsonString") as String?
                val gson = Gson()
                val playerConfiguration =
                    gson.fromJson(playerConfigJsonString, PlayerConfiguration::class.java)
                val intent =
                    Intent(activity?.applicationContext, UdevsVideoPlayerActivity::class.java)
                intent.putExtra(EXTRA_ARGUMENT, playerConfiguration)
                activity?.startActivityForResult(intent, PLAYER_ACTIVITY)
                resultMethod = result
            }
        } else if (call.method == "downloadVideo" || call.method == "checkIsDownloadedVideo" ||
            call.method == "getCurrentProgressDownload" || call.method == "pauseDownload" ||
            call.method == "resumeDownload"
        ) {
            if (call.hasArgument("downloadConfigJsonString")) {
                val downloadConfigJsonString = call.argument("downloadConfigJsonString") as String?
                val downloadConfiguration =
                    gson.fromJson(downloadConfigJsonString, DownloadConfiguration::class.java)
                val uri = Uri.parse(downloadConfiguration.url)
                val adaptiveMimeType: String? =
                    Util.getAdaptiveMimeTypeForContentType(Util.inferContentType(uri))
                val mediaItem = MediaItem.Builder()
                    .setUri(uri)
                    .setMediaMetadata(MediaMetadata.Builder().setTitle("My title").build())
                    .setMimeType(adaptiveMimeType).build()
                when (call.method) {
                    "downloadVideo" -> {
                        downloadTracker?.toggleDownload(mediaItem, renderersFactory)
                    }
                    "checkIsDownloadedVideo" -> {
                        val isDownloaded =
                            downloadTracker!!.isDownloaded(mediaItem)
                        result.success(isDownloaded)
                    }
                    "getCurrentProgressDownload" -> {
                        val progressDownload =
                            downloadTracker?.getCurrentProgressDownload(mediaItem)
                        result.success(progressDownload)
                    }
                    "pauseDownload" -> {
                        downloadTracker?.pauseAllDownloading()
                    }
                    "resumeDownload" -> {
                        downloadTracker?.resumeAllDownload()
                    }
                }
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        binding.addOnNewIntentListener(this)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        downloadTracker!!.removeListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
        downloadTracker!!.removeListener(this)
    }

    override fun onNewIntent(intent: Intent): Boolean {
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PLAYER_ACTIVITY && resultCode == PLAYER_ACTIVITY_FINISH) {
            resultMethod?.success(data?.getStringExtra("position"))
        }
        return true
    }


    /** Start the download service if it should be running but it's not currently.  */
    private fun startDownloadService(context: Context) {
        // Starting the service in the foreground causes notification flicker if there is no scheduled
        // action. Starting it in the background throws an exception if the app is in the background too
        // (e.g. if device screen is locked).
        try {
            DownloadService.start(context, MyDownloadService::class.java)
        } catch (e: IllegalStateException) {
            DownloadService.startForeground(
                context,
                MyDownloadService::class.java
            )
        }
    }

    override fun onDownloadsChanged(download: Download) {
        if (download.state == Download.STATE_DOWNLOADING) {
            val handler = Handler(Looper.getMainLooper())
            val runnable = object : Runnable {
                override fun run() {
                    try {
                        val percent = download.percentDownloaded.roundToInt()
                        if(percent == 100) {
                            handler.removeCallbacks(this)
                        } else {
                            val toJson =
                                gson.toJson(DownloadConfiguration(download.request.id, percent))
                            channel.invokeMethod("percent", toJson)
                            handler.postDelayed(this, 2000)
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            }
            handler.postDelayed(runnable, 2000)
        }
    }
}
