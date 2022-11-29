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
    func close()
    func swipe(_ json: String)
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
    
    private var isAnalyticSent: Bool = false
    
    private var activityIndicatorView: NVActivityIndicatorView = {
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: Colors.assets)
        return activityView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.closeCircle?.uiImage, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.swipe.uiImage, for: .normal)
        button.setTitleColor(Colors.black,for: .normal)
        button.backgroundColor = .clear
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
//        playButton.setTitle(buttonText, for: .normal)
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
        playButton.height(32)
        playButton.width(32)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
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
        let _url:String = playerConfiguration.baseUrl+"analytics"
        let result = Networking.sharedInstance.postAnalytics(_url, token: playerConfiguration.authorization, platform: playerConfiguration.platform, json: story.fromJson())
        switch result {
        case .failure(let error):
            print(error)
            break
        case .success(_):
            print("successfully posted analytics")
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
        if currentMoment >= 1 && !isAnalyticSent {
            isAnalyticSent = true
            let storyRequest = StoryAnalysticRequest(episodeKey: "0",isStory: true,movieKey: self.playerConfiguration.story[self.index].slug,seasonKey: "0",userId: self.playerConfiguration.userId,videoPlatform: self.playerConfiguration.story[self.index].isAmediateka ? "AMEDIATEKA" : "SHARQ")
            self.postAnalytics(story: storyRequest)
        }
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
    
    @objc private func didTapClose(_ sender: UITapGestureRecognizer) {
        postDelegate?.close()
    }
    
    @objc private func playClose() {
        let data:[String: Any] = ["slug": file.slug, "title": file.title, "story_link": file.storyLink]
        if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                postDelegate?.swipe(jsonString)
            }
        }
    }
}
