//
//  VideoPlayerDelegate.swift
//  udevs_video_player
//
//  Created by Udevs on 07/10/22.
//

import Foundation

protocol VideoPlayerDelegate: AnyObject {
    func getDuration(duration: Double)
}
protocol QualityDelegate {
    func qualityBottomSheet()
}
protocol SpeedDelegate {
    func speedBottomSheet()
}
