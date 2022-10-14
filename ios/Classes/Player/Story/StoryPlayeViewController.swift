//
//  VideoPlayerViewController.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit
import TinyConstraints
import MediaPlayer
import XLActionController
import NVActivityIndicatorView
import SnapKit
import AVKit
import AVFoundation

class StoryPlayerViewController: UIViewController{
    
    private var player = AVPlayer()
    private var playerLayer =  AVPlayerLayer()
    var playerConfiguration: PlayerConfiguration!
    weak var delegate: VideoPlayerDelegate?
    
    private var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private var overlayView: UIView = {
        let view = UIView()
        view.tag = 2
        view.layer.zPosition = 2
        view.backgroundColor =  UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.64)
        return view
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.exit.uiImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(StoryPlayerViewController.self, action: #selector(exitButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicatorView: NVActivityIndicatorView = {
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: .white)
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.moreColor
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        addSubviews()
        bottomView.clipsToBounds = true
        addConstraints()
        activityIndicatorView.startAnimating()
        setupDataSource(urlString: playerConfiguration.url)
    }
    
    func setupDataSource(urlString : String?){
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        /// video url player
        let urlAsset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: urlAsset)
        player.automaticallyWaitsToMinimizeStalling = true
        player.replaceCurrentItem(with: playerItem)
        /// video player
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        player.cancelPendingPrerolls()
        player.pause()
        playerLayer.player = nil
        playerLayer.removeFromSuperlayer()
        delegate?.close()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: - Hide Home Indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //@available(iOS 11, *)
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return nil
    }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    func addSubviews() {
        view.addSubview(videoView)
        view.addSubview(overlayView)
        overlayView.addSubview(topView)
        overlayView.addSubview(activityIndicatorView)
        overlayView.addSubview(bottomView)
        addTopViewSubviews()
    }

    func addTopViewSubviews() {
        topView.addSubview(exitButton)
    }
    
    func addConstraints() {
        addBottomViewConstraints()
        addTopViewConstraints()
        addControlButtonConstraints()
    }
    
    func addControlButtonConstraints(){
        activityIndicatorView.center(in: view)
        activityIndicatorView.layer.cornerRadius = 20
    }
    
    func addBottomViewConstraints() {
        bottomView.leading(to: view.safeAreaLayoutGuide, offset: Constants.horizontalSpacing)
        bottomView.trailing(to: view.safeAreaLayoutGuide, offset: -Constants.horizontalSpacing)
        bottomView.bottom(to: view.safeAreaLayoutGuide, offset: 0)
        bottomView.height(70)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addTopViewConstraints() {
        topView.leading(to: view.safeAreaLayoutGuide, offset: Constants.horizontalSpacing)
        topView.trailing(to: view.safeAreaLayoutGuide, offset: 0)
        topView.top(to: view.safeAreaLayoutGuide, offset: 10)
        topView.height(64)
        exitButton.width(Constants.topButtonSize)
        exitButton.height(Constants.topButtonSize)
        exitButton.right(to: topView)
        exitButton.centerY(to: topView)
        exitButton.layer.cornerRadius = Constants.topButtonSize / 2
    }

    
    @objc func exitButtonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }
    
    @objc func tapGestureControls() {
    }
       
}

extension StoryPlayerViewController {
}
// 1277
