//
//  FilesViewController.swift
//  Stories
//
//  Created by Sunnatillo Shavkatov on 27/06/2022.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView

protocol FileViewControllerDelegate: AnyObject {
    func didLongPress(_ vc: FileViewController, sender: UILongPressGestureRecognizer)
    func didTap(_ vc: FileViewController, sender: UITapGestureRecognizer)
    func videoEnded(_ vc: FileViewController)
}

final class FileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let file: Story
    var buttonText:String = ""
    let playerConfiguration: PlayerConfiguration
    let index: Int
    
    weak var postDelegate: FileViewControllerDelegate?
    weak var delegate: VideoPlayerDelegate?
    
    private let progress: CMTime = CMTimeMake(value: 4, timescale: 1)
    private var orientationLock = UIInterfaceOrientationMask.all
    
    private var timer: Timer?
    
    private var activityIndicatorView: NVActivityIndicatorView = {
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: Colors.assets)
        return activityView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.closeCircle.uiImage, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.playCircle.uiImage, for: .normal)
        button.setTitleColor(Colors.black,for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.layer.cornerRadius = 4
        button.backgroundColor = Colors.assets
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    public let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    var player: AVPlayer?
    
    public let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .white
        progressView.progressViewStyle = .default
        return progressView
    }()
    
    //MARK: Gesture
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tg.numberOfTapsRequired = 1
        tg.delegate = self
        return tg
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    
    //MARK: Init
    
    init(file: Story,playerConfiguration: PlayerConfiguration, index: Int) {
        self.file = file
        self.playerConfiguration = playerConfiguration
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        view.addGestureRecognizer(longPressGesture)
        view.addGestureRecognizer(tapGesture)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playClose), for: .touchUpInside)
        
        configurePlayer(with: file.fileName)
        configureTimer()
        playButton.setTitle(buttonText, for: .normal)
        activityIndicatorView.startAnimating()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storyDidEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
    }
    
    private func addSubviews() {
        view.addSubview(playerView)
        view.addSubview(closeButton)
        view.addSubview(progressView)
        view.addSubview(playButton)
        view.addSubview(activityIndicatorView)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let window = UIApplication.shared.keyWindow
        let topPadding: Int = Int(window?.safeAreaInsets.top ?? 0)
        
        closeButton.frame = CGRect(x: Int(view.width) - 45,
                                   y: 30+topPadding,
                                   width: 25,
                                   height: 25)

        playButton.leading(to: view.safeAreaLayoutGuide)
        playButton.trailing(to: view.safeAreaLayoutGuide)
        playButton.bottom(to: view.safeAreaLayoutGuide)
        playButton.height(42)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        playerView.frame = view.bounds
        playerView.center(in: view)
        
        progressView.frame = CGRect(x: 10,
                                    y: 10+topPadding,
                                    width: Int(view.width-closeButton.width),
                                    height: 10)
     
        
        activityIndicatorView.center(in: view)
        activityIndicatorView.layer.cornerRadius = 20
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        timer = nil
        player?.cancelPendingPrerolls()
        player?.pause()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if newValue != oldValue {
                if !playerConfiguration.story[index].isWatched && !(playerConfiguration.movieTrack?.userId.isEmpty ?? false){
                    postAnalytics(story: <#T##StoryAnalysticRequest#>.with(episodeKey: "0",isStory: true,movieKey: playerConfiguration.story[index].slug,seasonKey: "0",userId: playerConfiguration.movieTrack?.userId,videoPlatform: playerConfiguration.platform))
                }
                DispatchQueue.main.async {[weak self] in
                    if newValue == 2 {
                        self?.activityIndicatorView.stopAnimating()
                    } else if newValue == 0 {
                        self?.activityIndicatorView.stopAnimating()
                        self?.timer?.invalidate()
                    } else {
                        self?.activityIndicatorView.startAnimating()
                    }
                }
            }
        }
    }
    
    func postAnalytics(story: StoryAnalysticRequest) {
        var storyAnalyticResponse:StoryAnalyticResponse?
        let _url:String = playerConfiguration.baseUrl+"movie-track"
        let result = Networking.sharedInstance.postAnalytics(_url, token: playerConfiguration.authorization, platform: playerConfiguration.platform, json: story.fromJson())
        switch result {
        case .failure(let error):
            print(error)
            break
        case .success(let success):
            storyAnalyticResponse = success
            break
        }
        return 
    }
    
    private func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if let duration = self.player?.currentItem?.duration.seconds,
               let currentMoment = self.player?.currentItem?.currentTime().seconds {
                self.setProgressView(currentMoment, and: duration)
            }
        })
    }
    
    private func setProgressView(_ currentMoment: Double, and duration: Double) {
        progressView.progress = Float(currentMoment / duration)
    }
    
    private func configurePlayer(with video: String) {
        self.player = AVPlayer(url: URL(string: video)!)
        self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resize
        playerView.layer.addSublayer(playerLayer)
        playerLayer.player = player
        player?.play()
    }
    
    @objc private func storyDidEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            postDelegate?.videoEnded(self)
        }
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        postDelegate?.didLongPress(self, sender: sender)
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        postDelegate?.didTap(self, sender: sender)
    }
    
    @objc private func didTapClose() {
        self.dismiss(animated: true)
        delegate?.close(args: nil)
    }
    
    @objc private func playClose() {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(["slug": file.slug, "title":file.title]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                delegate?.close(args: jsonString)
            }
        }
        self.dismiss(animated: true)
    }
}
