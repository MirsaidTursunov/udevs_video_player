//
//  LinearProgressIndicator.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 25/07/2024.
//

import SwiftUI

@available(iOS 14, *)
struct CustomProgressViewStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
        if configuration.fractionCompleted! < 1.0 {
            ProgressView(value: configuration.fractionCompleted).frame(height: 4)
                .accentColor(Color(hex: 0x007AFF)).background(Color.white.opacity(0.7)) .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
      }
  }
}
