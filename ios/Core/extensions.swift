//
//  extensions.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 25/07/2024.
//

import Foundation
import SwiftUI

@available(iOS 13, *)
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
