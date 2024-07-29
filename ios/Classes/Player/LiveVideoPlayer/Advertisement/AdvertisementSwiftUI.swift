//
//  AdvertisementSwiftUI.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 24/07/2024.
//

import SwiftUI
import AVKit

@available(iOS 15, *)
struct AdvertisementSwiftUI: View {
    let advertisement: AdvertisementResponse
    let skipText: String
    
    @Environment(\.dismiss) var dismiss
    @State private var percent = 0.0
    @State private var player = AVPlayer()
    @State private var isImageLoaded = false
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            ZStack {
                if 
                    advertisement.video == nil || advertisement.video?.isEmpty ?? true
//               false
               {
                    AsyncImage(url: URL(string: advertisement.bannerImage?.mobileImage ??
                                        advertisement.bannerImage?.webImage ??  advertisement.bannerImage?.tvImage ?? "" )){result in
                        result.image?
                            .resizable()
                            .scaledToFit().onAppear{
                                isImageLoaded = true
                            }
                    }.onTapGesture(perform: {
                        if let url = URL(string: advertisement.link ?? "") {
                               UIApplication.shared.open(url)
                            }
                    })
                } else {
                    Button(action: {
                        if let url = URL(string: advertisement.link ?? "") {
                                                           UIApplication.shared.open(url)
                                                        }
                    }, label: {
                        VideoPlayer(player: player).onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            print("UI went background")
                            player.pause()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                            print("UI resumed")
                            if !player.isPlaying{
                                player.play()
                            }
                        }
                            .onAppear {
                                let url = URL(string: "https://test.cdn.uzdigital.tv/uzdigital/images/8cb238ae-bd88-4734-84f5-6bedc0f4c194.mp4")!
                                player = AVPlayer(url: url)
                                player.play()
                            }
                            .onDisappear {
                                player.pause()
                            }.allowsHitTesting(false)
                    })
                }
            }
           
            
            VStack{
                ProgressView(value: percent * 0.002)
                  .progressViewStyle(CustomProgressViewStyle())
                  .onAppear {
                      let duration = Double(advertisement.skipDuration ?? 15)
                      Timer.scheduledTimer(withTimeInterval: (duration * 2) / 1000.0, repeats: true) { timer in
                      if percent < 500 {
                          /// if image advertisement
                          if 
                            advertisement.video == nil || advertisement.video?.isEmpty ?? true
//                          false
                          {
                              if isImageLoaded {
                                  percent = percent + 1
                              }
                          } else if (player.rate != 0) && (player.error == nil) {
                              percent = percent + 1
                          }
                      } else {
                        timer.invalidate()
                      }
                    }
                  }
                Spacer()
                if !(percent < 500) {
                    Button {
                        dismiss()
                    } label: {
                        Text(skipText)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                                .fill(Color(hex: 0x1C192C))
                            )
                    }.transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                }
            }.padding(.horizontal,16)
        }
    }
}

//@available(iOS 15, *)
//#Preview {
//    AdvertisementSwiftUI()
//}
