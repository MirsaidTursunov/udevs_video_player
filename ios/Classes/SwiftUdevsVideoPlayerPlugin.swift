import Flutter
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
    public static var viewController = FlutterViewController()
    public var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
        let channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
        let instance = SwiftUdevsVideoPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result;
        if (call.method == "closePlayer" ) {
            SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated: true)
            return
        }
        if (call.method == "playVideo"){
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["playerConfigJsonString"] ?? "") else {
                return
            }
            let playerConfiguration : PlayerConfiguration = PlayerConfiguration.fromMap(map: json)
            
            guard URL(string: playerConfiguration.url) != nil else {
                return
            }
            let sortedResolutions = SortFunctions.sortWithKeys(playerConfiguration.resolutions)
            if (playerConfiguration.type == PlayerType.tv){
                let vc = TVVideoPlayerViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                vc.urlString = playerConfiguration.url
                vc.startPosition = playerConfiguration.lastPosition
                vc.resolutions = sortedResolutions
                vc.titleText = playerConfiguration.title
                vc.speedLabelText = playerConfiguration.speedText
                vc.qualityLabelText = playerConfiguration.qualityText
                vc.showsBtnText = playerConfiguration.tvProgramsText
                vc.programs = playerConfiguration.programsInfoList
                SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
            } else if (playerConfiguration.type == PlayerType.story){
                let vc = StoryPlayerViewController(video: Video(videoFiles: playerConfiguration.story),storyButtonText: playerConfiguration.storyButtonText,index: playerConfiguration.storyIndex)
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
            } else {
                let vc = VideoPlayerViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                vc.playerConfiguration = playerConfiguration
                vc.urlString = playerConfiguration.url
                vc.selectedSeason = playerConfiguration.seasonIndex
                vc.selectSesonNum = playerConfiguration.episodeIndex
                vc.startPosition = playerConfiguration.lastPosition
                vc.qualityLabelText = playerConfiguration.qualityText
                vc.speedLabelText = playerConfiguration.speedText
                vc.resolutions = sortedResolutions
                vc.selectedQualityText = playerConfiguration.autoText
                vc.titleText = playerConfiguration.title
                vc.serialLabelText = playerConfiguration.episodeButtonText
                vc.seasons  = playerConfiguration.seasons
                vc.movieTrack  = playerConfiguration.movieTrack
                SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
            }
        } else {
            result("iOS " + UIDevice.current.systemVersion);
        }
    }
    
    func getDuration(duration: Int) {
        flutterResult!("\(duration)")
    }
    
    func close(args:String?) {
        flutterResult!(args)
    }
}
