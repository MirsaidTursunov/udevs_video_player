package uz.udevs.udevs_video_player.double_tap_playerview

import android.annotation.SuppressLint
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.AttributeSet
import android.util.Log
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import androidx.core.view.GestureDetectorCompat
import androidx.media3.ui.PlayerView
import uz.udevs.udevs_video_player.R

/**
 * Custom player class for Double-Tapping listening
 */
open class DoubleTapPlayerView @JvmOverloads constructor(
    context: Context?, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : PlayerView(context!!, attrs, defStyleAttr) {

    private val gestureDetector: GestureDetectorCompat
    private val gestureListener: DoubleTapGestureListener = DoubleTapGestureListener(rootView)

    private var controller: PlayerDoubleTapListener? = null
        get() = gestureListener.controls
        set(value) {
            gestureListener.controls = value
            field = value
        }

    private var controllerRef: Int = -1

    init {
        gestureDetector = GestureDetectorCompat(context!!, gestureListener)

        // Check whether controller is set through XML
        attrs?.let {
            val a = context.obtainStyledAttributes(attrs, R.styleable.DoubleTapPlayerView, 0, 0)
            controllerRef =
                a.getResourceId(R.styleable.DoubleTapPlayerView_dtpv_controller, -1)

            a.recycle()
        }
    }

    var isDoubleTapEnabled = true

    var doubleTapDelay: Long = 700
        get() = gestureListener.doubleTapDelay
        set(value) {
            gestureListener.doubleTapDelay = value
            field = value
        }

    fun controller(controller: PlayerDoubleTapListener) = apply { this.controller = controller }

    /**
     * Returns the current state of double tapping.
     */
    fun isInDoubleTapMode(): Boolean = gestureListener.isDoubleTapping

    /**
     * Resets the timeout to keep in double tap mode.
     *
     * Called once in [PlayerDoubleTapListener.onDoubleTapStarted]. Needs to be called
     * from outside if the double tap is customized / overridden to detect ongoing taps
     */
    fun keepInDoubleTapMode() {
        gestureListener.keepInDoubleTapMode()
    }

    /**
     * Cancels double tap mode instantly by calling [PlayerDoubleTapListener.onDoubleTapFinished]
     */
    fun cancelInDoubleTapMode() {
        gestureListener.cancelInDoubleTapMode()
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(ev: MotionEvent): Boolean {
        if (isDoubleTapEnabled) {
            gestureDetector.onTouchEvent(ev)
            return true
        }
        return super.onTouchEvent(ev)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()

        // If the PlayerView is set by XML then call the corresponding setter method
        if (controllerRef != -1) {
            try {
                val view = (this.parent as View).findViewById(controllerRef) as View
                if (view is PlayerDoubleTapListener) {
                    controller(view)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e(
                    "DoubleTapPlayerView",
                    "controllerRef is either invalid or not PlayerDoubleTapListener: ${e.message}"
                )
            }
        }

    }

    /**
     * Gesture Listener for double tapping
     *
     * For more information which methods are called in certain situations look for
     * [GestureDetector.onTouchEvent][android.view.GestureDetector.onTouchEvent],
     * especially for ACTION_DOWN and ACTION_UP
     */
    private class DoubleTapGestureListener(private val rootView: View) :
        GestureDetector.SimpleOnGestureListener() {

        private val mHandler = Handler(Looper.getMainLooper())
        private val mRunnable = Runnable {
            if (DEBUG) Log.d(TAG, "Runnable called")
            isDoubleTapping = false
            controls?.onDoubleTapFinished()
        }

        var controls: PlayerDoubleTapListener? = null
        var isDoubleTapping = false
        var doubleTapDelay: Long = 650

        /**
         * Resets the timeout to keep in double tap mode.
         *
         * Called once in [PlayerDoubleTapListener.onDoubleTapStarted]. Needs to be called
         * from outside if the double tap is customized / overridden to detect ongoing taps
         */
        fun keepInDoubleTapMode() {
            isDoubleTapping = true
            mHandler.removeCallbacks(mRunnable)
            mHandler.postDelayed(mRunnable, doubleTapDelay)
        }

        /**
         * Cancels double tap mode instantly by calling [PlayerDoubleTapListener.onDoubleTapFinished]
         */
        fun cancelInDoubleTapMode() {
            mHandler.removeCallbacks(mRunnable)
            isDoubleTapping = false
            controls?.onDoubleTapFinished()
        }

        override fun onDown(e: MotionEvent): Boolean {
            if (isDoubleTapping) {
                controls?.onDoubleTapProgressDown(e.x, e.y)
                return true
            }
            return super.onDown(e)
        }

        override fun onShowPress(e: MotionEvent) = Unit

        override fun onSingleTapUp(e: MotionEvent): Boolean {
            if (isDoubleTapping) {
                if (DEBUG) Log.d(TAG, "onSingleTapUp: isDoubleTapping = true")
                controls?.onDoubleTapProgressUp(e.x, e.y)
                return true
            }
            return super.onSingleTapUp(e)
        }

        override fun onSingleTapConfirmed(e: MotionEvent): Boolean {
            if (isDoubleTapping) return true
            return rootView.performClick()
        }

        override fun onDoubleTap(e: MotionEvent): Boolean {
            if (!isDoubleTapping) {
                isDoubleTapping = true
                keepInDoubleTapMode()
                controls?.onDoubleTapStarted(e.x, e.y)
            }
            return true
        }

        override fun onDoubleTapEvent(e: MotionEvent): Boolean {
            if (e.actionMasked == MotionEvent.ACTION_UP && isDoubleTapping) {
                controls?.onDoubleTapProgressUp(e.x, e.y)
                return true
            }
            return super.onDoubleTapEvent(e)
        }

        override fun onLongPress(e: MotionEvent) = Unit
        override fun onFling(e1: MotionEvent, e2: MotionEvent, p2: Float, p3: Float): Boolean =
            false

        override fun onScroll(
            e1: MotionEvent,
            e2: MotionEvent,
            distanceX: Float,
            distanceY: Float
        ): Boolean {
            if (controls == null) {
                return true
            }
            return controls!!.onScroll(e1, e2, distanceX, distanceY)
        }

        companion object {
            private const val TAG = ".DTGListener"
            private var DEBUG = true
        }
    }

}