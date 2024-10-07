import Flutter
import AVFoundation
import AVFAudio
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
    public static var viewController = FlutterViewController()
    private var flutterResult: FlutterResult?
    private static var channel : FlutterMethodChannel?

    private var didRestorePersistenceManager = false
    fileprivate let downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    fileprivate var assetDownloadURLSession: AVAssetDownloadURLSession!
    fileprivate var activeDownloadsMap = [AVAggregateAssetDownloadTask: MediaItemDownload]()

    private var closeToRequestAuthTimer: Timer?

    override private init() {
        super.init()
        let configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        assetDownloadURLSession = AVAssetDownloadURLSession(configuration: configuration,
                                                            assetDownloadDelegate: self,
                                                            delegateQueue: OperationQueue.main)
        restorePersistenceManager()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        guard let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController else {
            return
        }
        self.viewController = viewController
        channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
        let instance = SwiftUdevsVideoPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
        let videoViewFactory = VideoPlayerViewFactory(registrar: registrar)
        registrar.register(videoViewFactory, withId: "plugins.udevs/video_player_view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result
        switch call.method {
        case "closePlayer":
            SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated: true)
            result(nil)
        case "downloadVideo":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            setupAssetDownload(download: download)
        case "pauseDownload":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            pauseDownload(for: download)
        case "resumeDownload":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            resumeDownload(for: download)
        case "getStateDownload":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
        case "getBytesDownloaded":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
        case "getContentBytesDownload":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
        case "checkIsDownloadedVideo":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["downloadConfigJsonString"] ?? "") else { return }
            let download: DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            isDownloadVideo(for: download)
        case "playVideo":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["playerConfigJsonString"] ?? "") else { return }
            let playerConfiguration: PlayerConfiguration = PlayerConfiguration.fromMap(map: json)
            let sortedResolutions = SortFunctions.sortWithKeys(playerConfiguration.resolutions)
            guard URL(string: playerConfiguration.url) != nil else { return }
            let vc = VideoPlayerViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.playerConfiguration = playerConfiguration
            vc.qualityLabelText = playerConfiguration.qualityText
            vc.speedLabelText = playerConfiguration.speedText
            vc.resolutions = sortedResolutions
            vc.selectedQualityText = playerConfiguration.autoText
            vc.seasons = playerConfiguration.seasons
            vc.selectChannelIndex = playerConfiguration.selectChannelIndex
            vc.selectTvCategoryIndex = playerConfiguration.selectTvCategoryIndex
            SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true, completion: nil)
//            wait3MinsAndClose(playerConfiguration: playerConfiguration)
        case "playLiveVideo":
            guard let args = call.arguments else { return }
            guard let json = convertStringToDictionary(text: (args as! [String: String])["livePlayerConfigJsonString"] ?? "") else { return }
            let playerConfiguration: LivePlayerConfiguration = LivePlayerConfiguration.fromMap(map: json)
            guard URL(string: playerConfiguration.videoUrl) != nil else { return }
            let vc = LiveVideoPlayerViewController(playerConfig: playerConfiguration)
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.qualityLabelText = playerConfiguration.qualityText
            vc.speedLabelText = playerConfiguration.speedText
            vc.selectedQualityText = playerConfiguration.autoText
            vc.selectChannelIndex = playerConfiguration.selectChannelIndex
            vc.selectTvCategoryIndex = playerConfiguration.selectTvCategoryIndex
            SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true, completion: nil)
            wait3MinsAndClose(playerConfiguration: playerConfiguration)
        default:
            result("Not Implemented")
        }
    }

    func getDuration(duration: Double) {
        flutterResult!(Int(duration))
    }

    private func getPercentComplete(download: MediaItemDownload) {
        SwiftUdevsVideoPlayerPlugin.channel?.invokeMethod("percent", arguments: download.fromString())
    }

    func restorePersistenceManager() {
        guard !didRestorePersistenceManager else { return }

        didRestorePersistenceManager = true

        assetDownloadURLSession.getAllTasks { tasksArray in
            for task in tasksArray {
                guard let assetDownloadTask = task as? AVAggregateAssetDownloadTask else { break }
                guard assetDownloadTask.urlAsset.url.absoluteString != nil else { break }
                let urlAsset = assetDownloadTask.urlAsset
                let asset = MediaItemDownload(url: urlAsset.url.absoluteString, percent: 100, state: nil, downloadedBytes: 0)
            }
        }
    }

    private func isDownloadVideo(for download: DownloadConfiguration) {
        guard UserDefaults.standard.value(forKey: download.url) is String else {
            flutterResult!(false)
            return
        }
        flutterResult!(true)
    }

    private func getStateDownload(for download: DownloadConfiguration) {
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where download.url == assetVal.url {
            task = taskKey
            break
        }
        flutterResult!(task?.state ?? MediaItemDownload.STATE_FAILED)
    }

    private func setupAssetDownload(download: DownloadConfiguration) {
        guard UserDefaults.standard.value(forKey: download.url) is String else {
            if let url = URL(string: download.url) {
                let asset = AVURLAsset(url: url)
                let preferredMediaSelection = asset.preferredMediaSelection
                guard let downloadTask = assetDownloadURLSession.aggregateAssetDownloadTask(with: asset, mediaSelections: [preferredMediaSelection],
                                                                                            assetTitle: "Some Title",
                                                                                            assetArtworkData: nil,
                                                                                            options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 265_000]) else { return }
                downloadTask.taskDescription = asset.description
                activeDownloadsMap[downloadTask] = MediaItemDownload(url: download.url, percent: 0, state: MediaItemDownload.STATE_RESTARTING, downloadedBytes: 0)
                downloadTask.resume()
            }
            return
        }
        getPercentComplete(download: MediaItemDownload(url: download.url, percent: 100, state: MediaItemDownload.STATE_COMPLETED, downloadedBytes: 0))
    }

    func cancelDownload(for asset: MediaItemDownload) {
        var task: AVAggregateAssetDownloadTask?

        for (taskKey, assetVal) in activeDownloadsMap where asset.url == assetVal.url {
            task = taskKey
            break
        }

        task?.cancel()
    }

    func pauseDownload(for asset: DownloadConfiguration) {
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where asset.url == assetVal.url {
            task = taskKey
            break
        }
        task?.suspend()
    }

    func resumeDownload(for asset: DownloadConfiguration) {
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where asset.url == assetVal.url {
            task = taskKey
            break
        }
        task?.resume()
    }

    private func wait3MinsAndClose(playerConfiguration: LivePlayerConfiguration) {
        if playerConfiguration.authorization.isEmpty {
            closeToRequestAuthTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(handleCloseToRequestAuth), userInfo: nil, repeats: false)
        }
    }

    @objc private func handleCloseToRequestAuth() {
        closeToRequestAuthTimer?.invalidate()
        closeToRequestAuthTimer = nil
        flutterResult?(-1)
        SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated: true, completion: nil)
    }
}

extension SwiftUdevsVideoPlayerPlugin: AVAssetDownloadDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }

    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        print("STATE \(aggregateAssetDownloadTask.state.rawValue)")
        if aggregateAssetDownloadTask.state.rawValue == 3 {
            print("rrrrr \(MediaItemDownload.STATE_COMPLETED)")
            self.getPercentComplete(download: MediaItemDownload(url: aggregateAssetDownloadTask.urlAsset.url.absoluteString, percent: 100, state: MediaItemDownload.STATE_COMPLETED, downloadedBytes: 0))
            UserDefaults.standard.set(location.relativePath, forKey: "\(aggregateAssetDownloadTask.urlAsset.url.absoluteURL)")
        }
    }

    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        print("TEst test")
        print(aggregateAssetDownloadTask.urlAsset.assetCache.hashValue)
        print(aggregateAssetDownloadTask.progress.fileTotalCount ?? 0)
        print(aggregateAssetDownloadTask.progress.totalUnitCount.byteSwapped)
        guard activeDownloadsMap[aggregateAssetDownloadTask] != nil else { return }

    }

    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection) {
        guard activeDownloadsMap[aggregateAssetDownloadTask] != nil else { return }
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange: CMTimeRange = value.timeRangeValue
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        print("STATE \(aggregateAssetDownloadTask.state.rawValue)")
        percentComplete *= 100
        self.getPercentComplete(download: MediaItemDownload(url: aggregateAssetDownloadTask.urlAsset.url.absoluteString, percent: Int(percentComplete), state: MediaItemDownload.STATE_DOWNLOADING, downloadedBytes: Int(aggregateAssetDownloadTask.countOfBytesReceived)))
        if percentComplete == 100 {
            self.getPercentComplete(download: MediaItemDownload(url: aggregateAssetDownloadTask.urlAsset.url.absoluteString, percent: Int(percentComplete), state: MediaItemDownload.STATE_COMPLETED, downloadedBytes: Int(aggregateAssetDownloadTask.countOfBytesReceived)))
        }
    }
}
