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
    let playerConfiguration: LivePlayerConfiguration
    let advertisement: AdvertisementResponse
    let skipText: String
    
    @Environment(\.dismiss) var dismiss
    @State private var percent = 0.0
    @State private var player = AVPlayer()
    @State private var isImageLoaded = false
    @State private var isClicked = false
    
    
    func sendAnalytics(interested:Bool) {
        let requestBody = AdvertisementAnalyticsRequest(
            id: advertisement.id ?? "", interested: interested || isClicked, click: isClicked, viewTime: advertisement.video == nil ? (advertisement.skipDuration ?? 15): Int(CMTimeGetSeconds(player.currentTime())) )
        let _url : String = playerConfiguration.baseUrl + "advertisingTest"
        let result = Networking.sharedInstance.sendAdvertisementAnalytics(_url, token: playerConfiguration.authorization, sessionId: playerConfiguration.sessionId,
                                                                analytics: requestBody
        )
        print("result adv analytics: \(result)")
    }
    
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
                            isClicked  = true
                            UIApplication.shared.open(url)
                        }
                    })
                } else {
                    Button(action: {
                        if let url = URL(string: advertisement.link ?? "") {
                            isClicked = true
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
                                let url = URL(string: advertisement.video ?? "")!
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
                          {
                              if isImageLoaded {
                                  percent = percent + 1
                              }
                          } else if (player.rate != 0) && (player.error == nil) {
                              percent = percent + 1
                          }
                      } else {
                          sendAnalytics(interested: false)
                          if(advertisement.video == nil){
                              dismiss()
                          }
                        timer.invalidate()
                      }
                    }
                  }
                Spacer()
                if !(percent < 500) {
                    Button {
                        sendAnalytics(interested: false)
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
