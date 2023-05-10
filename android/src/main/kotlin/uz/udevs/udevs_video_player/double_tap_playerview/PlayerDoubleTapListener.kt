package uz.udevs.udevs_video_player.double_tap_playerview

import android.view.MotionEvent


interface PlayerDoubleTapListener {

    fun onDoubleTapStarted(posX: Float, posY: Float) {}

    fun onDoubleTapProgressDown(posX: Float, posY: Float) {}

    fun onDoubleTapProgressUp(posX: Float, posY: Float) {}

    fun onDoubleTapFinished() {}
    fun onScroll(
        e1: MotionEvent,
        e2: MotionEvent,
        distanceX: Float,
        distanceY: Float
    ): Boolean {
        return false
    }
}