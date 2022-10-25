//
//  VideoPlayerViewController.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit
import TinyConstraints
import AVFoundation
import MediaPlayer
import XLActionController
import NVActivityIndicatorView
import SnapKit

class VideoPlayerViewController: UIViewController, SettingsBottomSheetCellDelegate, BottomSheetCellDelegate {
    
    struct Constants {
        static let horizontalSpacing: CGFloat = 0
        static let controlButtonSize: CGFloat = 55.0
        static let maxButtonSize: CGFloat = 40.0
        static let bottomViewButtonSize: CGFloat = 16
        static let unblockButtonSize : CGFloat = 32.0
        static let unblockButtonInset : CGFloat = 24.0
        static let bottomViewButtonInset: CGFloat = 24.0
        static let topButtonSize: CGFloat = 50.0
        static let controlButtonInset: CGFloat = 48
        static let alphaValue: CGFloat = 0.3
        static let topButtonInset: CGFloat = 34
        static let nextEpisodeInset: CGFloat = 20
        static let nextEpisodeShowTime : Float = 60
    }
    private var speedList = ["0.5","1.0","1.25","1.5","2.0"].sorted()
    private var seasonList = ["1-сезон","2-сезон","3-сезон","4-сезон","5-сезон"]
    private var player = AVPlayer()
    private var playerLayer =  AVPlayerLayer()
    private var playerItemContext = 0
    weak var delegate: VideoPlayerDelegate?
    var urlString: String?
    var qualityLabelText = ""
    var speedLabelText = ""
    var startPosition: Int?
    var titleText: String?
    var isRegular: Bool = false
    var resolutions: [String:String]?
    var sortedResolutions: [String] = []
    var isSerial = false
    var serialLabelText = ""
    var seasons : [Season] = [Season]()
    var shouldHideHomeIndicator = false
    var qualityDelegate: QualityDelegate!
    var speedDelegte: SpeedDelegate!
    var playerConfiguration: PlayerConfiguration!
    private var swipeGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    private var tapHideGesture: UITapGestureRecognizer!
    private var panDirection = SwipeDirection.vertical
    private var isVolume = false
    private var volumeViewSlider: UISlider!
    private var timer: Timer?
    private var seekForwardTimer: Timer?
    private var seekBackwardTimer: Timer?
    private var playerRate = 1.0
    var selectedSeason: Int = 0
    var selectSesonNum: Int = 0
    private var selectedSpeedText = "1.0x"
    var selectedQualityText = "Auto"
    private var selectedAudioTrack = "None"
    private var selectedSubtitle = "None"
    
    
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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private var landscapeButton: UIButton = {
        let button = UIButton()
        if (UIDevice.current.orientation.isLandscape) {
            button.setImage(Svg.horizontal.uiImage, for: .normal)
        } else {
            button.setImage(Svg.portrait.uiImage, for: .normal)
        }
        button.addTarget(self, action: #selector(changeOrientation(_:)), for: .touchUpInside)
        return button
    }()
    
    private var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var durationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    private var leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private var seperatorLabel: UILabel = {
        let label = UILabel()
        label.text = " / "
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var blockBottomView: UIView = {
        let view = UIView()
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
    
    //MARK: - BottomActionsStackView
    private lazy var bottomActionsStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [episodesButton,nextEpisodeButton, landscapeButton])
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    //MARK: - *************Time Stack View ***************
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeSlider])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        return stackView
    }()
    
    private var timeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Colors.mainColor
        slider.maximumTrackTintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.exit.uiImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(exitButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.play.uiImage, for: .normal)
        button.tintColor = .white
        button.layer.zPosition = 5
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: Constants.controlButtonInset, left: Constants.controlButtonInset, bottom: Constants.controlButtonInset, right: Constants.controlButtonInset)
        button.size(CGSize(width: 48, height: 48))
        button.addTarget(self, action: #selector(playButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var skipForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.forward.uiImage, for: .normal)
        button.tintColor = .white
        button.layer.zPosition = 3
        button.imageView?.contentMode = .scaleAspectFit
        button.size(CGSize(width: 48, height: 48))
        button.addTarget(self, action: #selector(skipForwardButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var skipBackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.replay.uiImage, for: .normal)
        button.tintColor = .white
        button.layer.zPosition = 3
        button.size(CGSize(width: 48, height: 48))
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(skipBackButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var episodesButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.serial.uiImage, for: .normal)
        button.setTitle("", for: .normal)
        button.layer.zPosition = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(episodesButtonPressed(_:)), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    private var nextEpisodeButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.next.uiImage, for: .normal)
        button.setTitle("", for: .normal)
        button.layer.zPosition = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(nextEpisodeButtonPressed(_:)), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    private var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.more.uiImage, for: .normal)
        button.layer.zPosition = 3
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        button.imageEdgeInsets = UIEdgeInsets(top: Constants.bottomViewButtonInset, left: 0, bottom: Constants.bottomViewButtonInset, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingPressed(_ :)), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    private var activityIndicatorView: NVActivityIndicatorView = {
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: Colors.assets)
        return activityView
    }()
    
    private var portraitConstraints = Constraints()
    private var landscapeConstraints = Constraints()
    private var enableGesture = true
    private var backwardGestureTimer: Timer?
    private var forwardGestureTimer: Timer?
    private var backwardTouches = 0
    private var forwardTouches = 0
    
    func setupDataSource(title : String?, urlString : String?, startAt : Int64?){
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        let urlAsset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: urlAsset)
        player.automaticallyWaitsToMinimizeStalling = true
        player.replaceCurrentItem(with: playerItem)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
        
        self.titleLabel.text = title ?? ""
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        selectedAudioTrack = player.currentItem?.selected(type: .audio) ?? "None"
        selectedSubtitle = player.currentItem?.selected(type: .subtitle) ?? "None"
    }
    
    func runPlayer(startAt: Int){
        selectedAudioTrack = player.currentItem?.selected(type: .audio) ?? "None"
        selectedSubtitle = player.currentItem?.selected(type: .subtitle) ?? "None"
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(40000)
        player.automaticallyWaitsToMinimizeStalling = true;
        player.seek(to:CMTimeMakeWithSeconds(Float64(Float(startAt)),preferredTimescale: 1000))
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let resList = resolutions ?? ["480p":urlString!]
        sortedResolutions = Array(resList.keys).sorted().reversed()
        //        episodesButton.setTitle(serialLabelText, for: .normal)
        Array(resList.keys).sorted().reversed().forEach { quality in
            if quality == "1080p"{
                sortedResolutions.removeLast()
                sortedResolutions.insert("1080p", at: 1)
            }
        }
        view.backgroundColor = Colors.moreColor
        if #available(iOS 13.0, *) {
            let value = UIInterfaceOrientationMask.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
        }
        
        if #available(iOS 13.0, *) {
            setSliderThumbTintColor(Colors.mainColor)
        } else {
            timeSlider.thumbTintColor = Colors.moreColor
        }
        view.backgroundColor = .black
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        addSubviews()
        pinchGesture()
        bottomView.clipsToBounds = true
        timeSlider.clipsToBounds = true
        addConstraints()
        addGestures()
        playButton.alpha = 0.0
        activityIndicatorView.startAnimating()
        setupDataSource(title: titleText, urlString: urlString, startAt: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (selectedSpeedText == speedList[1]) {
            isRegular = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        resetTimer()
        configureVolume()
        runPlayer(startAt: startPosition ?? 0)
        self.shouldHideHomeIndicator = true
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        player.cancelPendingPrerolls()
        player.pause()
        playerLayer.player = nil
        playerLayer.removeFromSuperlayer()
        delegate?.getDuration(duration: player.currentTime().seconds)
        let value = UIInterfaceOrientationMask.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight{
            addVideosLandscapeConstraints()
        } else {
            addVideoPortaitConstraints()
        }
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
    
    func addGestures(){
        swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePan))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureControls))
        
        view.addGestureRecognizer(swipeGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    func addSubviews() {
        view.addSubview(videoView)
        view.addSubview(overlayView)
        overlayView.addSubview(topView)
        overlayView.addSubview(playButton)
        overlayView.addSubview(skipForwardButton)
        view.addSubview(skipForwardButton)
        overlayView.addSubview(skipBackwardButton)
        view.addSubview(skipBackwardButton)
        overlayView.addSubview(activityIndicatorView)
        overlayView.addSubview(bottomView)
        //        overlayView.addSubview(landscapeButton)
        addTopViewSubviews()
        addBottomViewSubviews()
    }
    
    //MARK: - addBottomViewSubviews
    func addBottomViewSubviews() {
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(durationTimeLabel)
        bottomView.addSubview(seperatorLabel)
        bottomView.addSubview(timeSlider)
        bottomView.addSubview(timeStackView)
        bottomView.addSubview(bottomActionsStackView)
    }
    
    func addTopViewSubviews() {
        topView.addSubview(exitButton)
        topView.addSubview(titleLabel)
        topView.addSubview(settingsButton)
    }
    
    func addConstraints() {
        addVideosLandscapeConstraints1()
        addBottomViewConstraints()
        addTopViewConstraints()
        addControlButtonConstraints()
    }
    
    func addControlButtonConstraints(){
        playButton.center(in: view)
        playButton.width(Constants.controlButtonSize)
        playButton.height(Constants.controlButtonSize)
        playButton.layer.cornerRadius = Constants.controlButtonSize/2
        skipBackwardButton.width(Constants.controlButtonSize)
        skipBackwardButton.height(Constants.controlButtonSize)
        skipBackwardButton.rightToLeft(of: playButton, offset: -60)
        skipBackwardButton.top(to: playButton)
        skipBackwardButton.layer.cornerRadius = Constants.controlButtonSize/2
        skipForwardButton.width(Constants.controlButtonSize)
        skipForwardButton.height(Constants.controlButtonSize)
        skipForwardButton.leftToRight(of: playButton, offset: 60)
        skipForwardButton.top(to: playButton)
        skipForwardButton.layer.cornerRadius = Constants.controlButtonSize/2
        activityIndicatorView.center(in: view)
        activityIndicatorView.layer.cornerRadius = 20
    }
    
    func addBottomViewConstraints() {
        var bottomPad: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            bottomPad = -5
        } else {
            bottomPad = 5
        }
        
        bottomView.leading(to: view.safeAreaLayoutGuide, offset: Constants.horizontalSpacing)
        bottomView.trailing(to: view.safeAreaLayoutGuide, offset: -Constants.horizontalSpacing)
        bottomView.bottom(to: view.safeAreaLayoutGuide, offset: 0)
        bottomView.height(80)
        
        timeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        if (isSerial) {
            bottomActionsStackView.snp.makeConstraints { make in
                make.right.equalTo(bottomView).offset(-16)
            }
//        } else {
//            bottomActionsStackView.snp.makeConstraints { make in
//                make.left.equalToSuperview().offset(80)
//                make.right.equalToSuperview().offset(-80)
//            }
//        }
        bottomActionsStackView.bottomToTop(of: timeSlider, offset: 0)
        
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(bottomView).offset(16)
        }
        currentTimeLabel.bottomToTop(of: timeSlider, offset: bottomPad)
        
        seperatorLabel.leftToRight(of: currentTimeLabel)
        seperatorLabel.centerY(to: currentTimeLabel)
        durationTimeLabel.leftToRight(of: seperatorLabel)
        durationTimeLabel.bottomToTop(of: timeSlider, offset: bottomPad)
        //        landscapeButton.bottomToTop(of: timeSlider, offset: 0)
        //        landscapeButton.snp.makeConstraints { make in
        //            make.right.equalTo(bottomView).offset(-16)
        //        }
        
        //        nextEpisodeButton.width(48)
        //        nextEpisodeButton.height(48)
        nextEpisodeButton.layer.cornerRadius = 8
        //        nextEpisodeButton.snp.makeConstraints{ make in
        //            make.right.equalTo(landscapeButton).offset(-12)
        //        }
        
        //        episodesButton.width(48)
        //        episodesButton.height(48)
        //        episodesButton.snp.makeConstraints{ make in
        //            make.right.equalTo(nextEpisodeButton).offset(-12)
        //        }
        episodesButton.layer.cornerRadius = 8
        
        if !isSerial {
            episodesButton.isHidden = true
            nextEpisodeButton.isHidden = true
        }
    }
    
    func addTopViewConstraints() {
        topView.leading(to: view.safeAreaLayoutGuide, offset: Constants.horizontalSpacing)
        topView.trailing(to: view.safeAreaLayoutGuide, offset: 0)
        topView.top(to: view.safeAreaLayoutGuide, offset: 10)
        topView.height(64)
        
        // title
        titleLabel.centerY(to: topView)
        titleLabel.centerX(to: topView)
        titleLabel.left(to: exitButton, offset: 56)
        titleLabel.right(to: settingsButton, offset: -56)
        titleLabel.layoutMargins = .horizontal(16)
        
        exitButton.width(Constants.topButtonSize)
        exitButton.height(Constants.topButtonSize)
        exitButton.left(to: topView)
        exitButton.centerY(to: topView)
        exitButton.layer.cornerRadius = Constants.topButtonSize/2
        
        settingsButton.width(50)
        settingsButton.height(Constants.bottomViewButtonSize)
        settingsButton.layer.cornerRadius = 8
        settingsButton.right(to: topView)
        settingsButton.centerY(to: topView)
        
    }
    
    func addVideosLandscapeConstraints1() {
        portraitConstraints.deActivate()
        landscapeConstraints.append(contentsOf: videoView.edgesToSuperview())
    }
    
    func addVideosLandscapeConstraints() {
        portraitConstraints.deActivate()
        landscapeButton.setImage(Svg.horizontal.uiImage, for: .normal)
        nextEpisodeButton.setTitle(" "+playerConfiguration.nextButtonText, for: .normal)
        episodesButton.setTitle(" "+playerConfiguration.episodeButtonText, for: .normal)
        landscapeConstraints.append(contentsOf: videoView.edgesToSuperview())
    }
    
    func addVideoPortaitConstraints() {
        landscapeConstraints.deActivate()
        let width = view.frame.width
        let heigth = width * 9 / 16
        nextEpisodeButton.setTitle("", for: .normal)
        episodesButton.setTitle("", for: .normal)
        landscapeButton.setImage(Svg.portrait.uiImage, for: .normal)
        portraitConstraints.append(contentsOf: videoView.center(in: view))
        portraitConstraints.append(contentsOf: videoView.height(min: heigth, max: view.frame.height, priority: .defaultLow, isActive: true))
        portraitConstraints.append(videoView.left(to: view))
        portraitConstraints.append(videoView.right(to: view))
    }
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func setSliderThumbTintColor(_ color: UIColor) {
        let circleImage = makeCircleWith(size: CGSize(width: 28, height: 28),
                                         backgroundColor: color)
        timeSlider.setThumbImage(circleImage, for: .normal)
        timeSlider.setThumbImage(circleImage, for: .highlighted)
    }
    
    func configureVolume() {
        let volumeView = MPVolumeView()
        for view in volumeView.subviews {
            if let slider = view as? UISlider {
                self.volumeViewSlider = slider
            }
        }
    }
    
    //MARK: - Buttons logic
    @objc func playButtonPressed(_ sender: UIButton){
        if !player.isPlaying {
            player.play()
            playButton.setImage(Svg.pause.uiImage, for: .normal)
            self.player.preroll(atRate: Float(self.playerRate), completionHandler: nil)
            self.player.rate = Float(self.playerRate)
            resetTimer()
        } else {
            playButton.setImage(Svg.play.uiImage, for: .normal)
            player.pause()
            timer?.invalidate()
            showControls()
        }
    }
    
    @objc func nextEpisodeButtonPressed(_ sender: UIButton){
        if seasons[selectedSeason].movies.count > selectSesonNum+1 {
            DispatchQueue.main.async {
                self.nextEpisode(seasonIndex: self.selectedSeason, episodeIndex: self.selectSesonNum+1)
            }
            return
        } else if seasons.count > selectedSeason+1{
            DispatchQueue.main.async {
                self.nextEpisode(seasonIndex: self.selectedSeason+1, episodeIndex: 0)
            }
            return
        }
    }
    
    
    @objc func exitButtonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func changeOrientation(_ sender: UIButton){
        var value  = UIInterfaceOrientation.landscapeRight.rawValue
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            value = UIInterfaceOrientation.portrait.rawValue
            videoView.backgroundColor = .black
        }
        UIDevice.current.setValue(value, forKey: "orientation")
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return
            }
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) ? .portrait : .landscapeRight)){
                    error in
                    print(error)
                    print(windowScene.effectiveGeometry)
                }
            })
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    @objc func skipBackButtonPressed(_ sender: UIButton){
        self.backwardTouches += 1
        self.seekBackwardTo(10.0 * Double(self.backwardTouches))
        self.backwardGestureTimer?.invalidate()
        self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.backwardTouches = 0
        }
        resetTimer()
    }
    
    @objc func skipForwardButtonPressed(_ sender: UIButton){
        self.forwardTouches += 1
        self.seekForwardTo(10.0 * Double(self.forwardTouches))
        self.forwardGestureTimer?.invalidate()
        self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.forwardTouches = 0
        }
        resetTimer()
    }
    
    func updateSeasonNum(index:Int) {
        selectedSeason = index
    }
    
    //MARK: - ****** SEASONS *******
    @objc func episodesButtonPressed(_ sender: UIButton){
        let episodeVC = EpisodeCollectionUI()
        episodeVC.modalPresentationStyle = .custom
        episodeVC.seasons = self.seasons
        episodeVC.delegate = self
        episodeVC.selectedSeasonIndex = self.selectedSeason
        episodeVC.closeText = self.playerConfiguration.closeText
        episodeVC.seasonText = self.playerConfiguration.seasonText
        self.present(episodeVC, animated: true, completion: nil)
    }
    
    @objc func settingPressed(_ sender: UIButton) {
        let vc = SettingVC()
        vc.modalPresentationStyle = .custom
        vc.delegete = self
        vc.speedDelegate = self
        vc.settingModel = [
            SettingModel(leftIcon: Svg.settings.uiImage, title: qualityLabelText, configureLabel: selectedQualityText),
            SettingModel(leftIcon: Svg.playSpeed.uiImage, title: speedLabelText, configureLabel:  selectedSpeedText)
        ]
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func seekForwardTo(_ seekPosition: Double) {
        guard let duration = player.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + seekPosition
        if newTime < (CMTimeGetSeconds(duration) - seekPosition) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
    }
    
    fileprivate func seekBackwardTo(_ seekPosition: Double) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - seekPosition
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationTimeLabel.text = VGPlayerUtils.getTimeString(from: player.currentItem!.duration)
        }
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if newValue != oldValue {
                DispatchQueue.main.async {[weak self] in
                    if newValue == 2 {
                        self?.playButton.setImage(Svg.pause.uiImage, for: .normal)
                        self?.playButton.alpha = self?.skipBackwardButton.alpha ?? 0.0
                        self?.activityIndicatorView.stopAnimating()
                        self?.enableGesture = true
                    } else if newValue == 0 {
                        self?.playButton.setImage(Svg.play.uiImage, for: .normal)
                        self?.playButton.alpha = self?.skipBackwardButton.alpha ?? 0.0
                        self?.activityIndicatorView.stopAnimating()
                        self?.enableGesture = true
                        self?.timer?.invalidate()
                        self?.showControls()
                    } else {
                        self?.playButton.alpha = 0.0
                        self?.activityIndicatorView.startAnimating()
                        self?.enableGesture = false
                    }
                }
            }
        }
    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {[weak self] in
            self?.player.seek(to: CMTime.zero)
            self?.playButton.setImage(Svg.play.uiImage, for: .normal)
        }
    }
    
    //MARK: - Time logic
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            
            guard currentItem.duration >= .zero, !currentItem.duration.seconds.isNaN else {
                return
            }
            let newDurationSeconds = Float(currentItem.duration.seconds)
            self?.timeSlider.maximumValue = Float(newDurationSeconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            let remainTime = Double(newDurationSeconds) - currentItem.currentTime().seconds
            _ = CMTimeMake(value: Int64(remainTime), timescale: 1)
            self?.currentTimeLabel.text = VGPlayerUtils.getTimeString(from: currentItem.currentTime())
        })
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    func resetSeekForwardTimer() {
        seekForwardTimer?.invalidate()
        seekForwardTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hideSeekForwardButton), userInfo: nil, repeats: false)
    }
    
    func resetSeekBackwardTimer() {
        seekBackwardTimer?.invalidate()
        seekBackwardTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hideSeekBackwardButton), userInfo: nil, repeats: false)
    }
    
    private func pinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didpinch))
        videoView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func didpinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            if scale < 0.9 {
                self.playerLayer.videoGravity = .resizeAspect
            }else {
                self.playerLayer.videoGravity = .resizeAspectFill
            }
            resetTimer()
        }
    }
    
    @objc func hideControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 0.0
            topView.alpha = alpha
            skipForwardButton.alpha = alpha
            overlayView.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            skipBackwardButton.alpha = alpha
            bottomView.alpha = alpha
        }, completion: nil)
    }
    
    @objc func hideSeekForwardButton() {
        if topView.alpha == 0 {
            let options: UIView.AnimationOptions = [.curveEaseIn]
            UIView.animate(withDuration: 0.1, delay: 0.1, options: options, animations: {[self] in
                let alpha = 0.0
                skipForwardButton.alpha = alpha
            }, completion: nil)
        }
    }
    
    @objc func hideSeekBackwardButton() {
        if topView.alpha == 0 {
            let options: UIView.AnimationOptions = [.curveEaseIn]
            UIView.animate(withDuration: 0.1, delay: 0.1, options: options, animations: {[self] in
                let alpha = 0.0
                skipBackwardButton.alpha = alpha
            }, completion: nil)
        }
    }
    
    func showSeekForwardButton(){
        skipForwardButton.alpha = 1.0
    }
    func showSeekBackwardButton(){
        skipBackwardButton.alpha = 1.0
    }
    
    @objc func hideBlockControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            _ = 0.0
        }, completion: nil)
    }
    
    func showBlockControls(){
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 1.0
            topView.alpha = alpha
            resetTimer()
        }, completion: nil)
    }
    
    func showControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 1.0
            topView.alpha = alpha
            skipForwardButton.alpha = alpha
            skipBackwardButton.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            bottomView.alpha = alpha
        }, completion: nil)
        
    }
    
    func toggleViews() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.05, delay: 0, options: options, animations: {[self] in
            let alpha = topView.alpha == 0.0 ? 1.0 : 0.0
            topView.alpha = alpha
            overlayView.alpha = alpha
            skipForwardButton.alpha = alpha
            skipBackwardButton.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            
            bottomView.alpha = alpha
            
            if(alpha == 1.0){
                resetTimer()
            }
        }, completion: nil)
    }
    
    @objc func tapGestureControls() {
        
        let location = tapGesture.location(in: view)
        
        if location.x > view.bounds.width / 2 + 50 {
            self.fastForward()
        } else if location.x <= view.bounds.width / 2 - 50 {
            self.fastBackward()
        } else {
            toggleViews()
        }
    }
    
    func fastForward() {
        self.forwardTouches += 1
        if forwardTouches < 2{
            self.forwardGestureTimer?.invalidate()
            self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.forwardTouches = 0
                self.toggleViews()
            }
        } else {
            self.showSeekForwardButton()
            self.seekForwardTo(10.0 * Double(self.forwardTouches))
            self.forwardGestureTimer?.invalidate()
            self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.forwardTouches = 0
                self.resetSeekForwardTimer()
            }
        }
    }
    func fastBackward() {
        self.backwardTouches += 1
        if backwardTouches < 2{
            self.backwardGestureTimer?.invalidate()
            self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.backwardTouches = 0
                self.toggleViews()
            }
        } else {
            self.showSeekBackwardButton()
            self.seekBackwardTo(10.0 * Double(self.backwardTouches))
            self.backwardGestureTimer?.invalidate()
            self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.backwardTouches = 0
                self.resetSeekBackwardTimer()
            }
        }
    }
    
    @objc func swipePan() {
        let locationPoint = swipeGesture.location(in: view)
        
        let velocityPoint = swipeGesture.velocity(in: view)
        
        switch swipeGesture.state {
        case .began:
            
            let x = abs(velocityPoint.x)
            let y = abs(velocityPoint.y)
            
            if x > y {
                panDirection = SwipeDirection.horizontal
            } else {
                panDirection = SwipeDirection.vertical
                if locationPoint.x > view.bounds.size.width / 2 {
                    isVolume = true
                } else {
                    isVolume = false
                }
            }
            
        case UIGestureRecognizer.State.changed:
            switch panDirection {
            case SwipeDirection.horizontal:
                //                horizontalMoved(velocityPoint.x)
                break
            case SwipeDirection.vertical:
                verticalMoved(velocityPoint.y)
                break
            }
            
        case UIGestureRecognizer.State.ended:
            switch panDirection {
            case SwipeDirection.horizontal:
                break
            case SwipeDirection.vertical:
                isVolume = false
                break
            }
        default:
            break
        }
    }
    
    func verticalMoved(_ value: CGFloat) {
        if isVolume{
            self.volumeViewSlider.value -= Float(value / 10000)
        }
        else{
            UIScreen.main.brightness -= value / 10000
        }
    }
    
    func changeUrl(url:String?, title: String?){
        guard let videoURL = URL(string: url ?? "") else {
            return
        }
        self.titleLabel.text = title ?? ""
        let currentTime = CMTime.zero
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.seek(to: currentTime)
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(1)
        self.player.automaticallyWaitsToMinimizeStalling = true
    }
    
    // settings bottom sheet tapped
    func onSettingsBottomSheetCellTapped(index: Int) {
        switch index {
        case 0:
            showQualityBottomSheet()
            break
        case 1:
            showSpeedBottomSheet()
            break
        case 2:
            //            showSubtitleBottomSheet()
            break
        case 3:
            //            showAudioTrackBottomSheet()
            break
        default:
            break
        }
    }
    
    //    //MARK: - Bottom Sheets Configurations
    // bottom sheet tapped
    func onBottomSheetCellTapped(index: Int, type : BottomSheetType) {
        switch type {
        case .quality:
            let resList = resolutions ?? ["480p":urlString!]
            _ = Array(resList.keys)
            self.selectedQualityText = sortedResolutions[index]
            let url = resList[sortedResolutions[index]]
            guard let videoURL = URL(string: url ?? "") else {
                return
            }
            let currentTime = self.player.currentTime()
            let asset = AVURLAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.seek(to: currentTime)
            self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(1)
            self.player.automaticallyWaitsToMinimizeStalling = true
            break
        case .speed:
            self.playerRate =  Double(speedList[index])!
            self.selectedSpeedText = isRegular  ? "\(self.playerRate)x(Обычный)" : "\(self.playerRate)x"
            self.player.preroll(atRate: Float(self.playerRate), completionHandler: nil)
            self.player.rate = Float(self.playerRate)
            break
        case .subtitle:
            var subtitles = player.currentItem?.tracks(type: .subtitle) ?? ["None"]
            subtitles.insert("None", at: 0)
            let selectedSubtitleLabel = subtitles[index]
            if ((player.currentItem?.select(type: .subtitle, name: selectedSubtitleLabel)) != nil){
                selectedSubtitle = selectedSubtitleLabel
            }
            break
            
        case .audio:
            let audios = player.currentItem?.tracks(type: .audio) ?? ["None"]
            let selectedAudio = audios[index]
            if ((player.currentItem?.select(type: .audio, name: selectedAudio)) != nil){
                selectedAudioTrack = selectedAudio
            }
            break
        }
    }
    
    func showQualityBottomSheet(){
        let resList = resolutions ?? ["480p":urlString!]
        let array = Array(resList.keys)
        var listOfQuality = [String]()
        listOfQuality = array.sorted().reversed()
        array.sorted().reversed().forEach { quality in
            if quality == "1080p"{
                listOfQuality.removeLast()
                listOfQuality.insert("1080p", at: 1)
            }
        }
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.items = listOfQuality
        bottomSheetVC.labelText = qualityLabelText
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.bottomSheetType = .quality
        bottomSheetVC.selectedIndex = listOfQuality.firstIndex(of: selectedQualityText) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
    
    func showSpeedBottomSheet(){
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.items = speedList
        bottomSheetVC.labelText = speedLabelText
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.bottomSheetType = .speed
        bottomSheetVC.selectedIndex = speedList.firstIndex(of: "\(self.playerRate)") ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
    
    func getMegogoStream(parameters:[String:String], id:String) -> MegogoStreamResponse? {
        var megogoResponse:MegogoStreamResponse?
        let _url:String = playerConfiguration.baseUrl+"megogo/stream"
        let result = Networking.sharedInstance.getMegogoStream(_url, token: self.playerConfiguration.authorization, sessionId: id, parameters: parameters)
        switch result {
        case .failure(let error):
            print(error)
            break
        case .success(let success):
            megogoResponse = success
            break
        }
        return megogoResponse
        
    }
    
    func getPremierStream(episodeId:String) -> PremierStreamResponse?{
        let _url : String = playerConfiguration.baseUrl+"premier/videos/\(playerConfiguration.videoId)/episodes/\(episodeId)/stream"
        var premierSteamResponse: PremierStreamResponse?
        let result = Networking.sharedInstance.getPremierStream(_url, token: playerConfiguration.authorization, sessionId: playerConfiguration.sessionId)
        switch result {
        case .failure(let error):
            print(error)
        case .success(let success):
            premierSteamResponse = success
        }
        return premierSteamResponse
    }
    
    func playSeason(_resolutions : [String:String],startAt:Int64?,_episodeIndex:Int,_seasonIndex:Int ){
        self.selectedSeason = _seasonIndex
        self.selectSesonNum = _episodeIndex
        self.resolutions = SortFunctions.sortWithKeys(_resolutions)
        let isFinded = resolutions?.contains(where: { (key, value) in
            if key == self.selectedQualityText {
                return true
            }
            return false
        }) ?? false
        let title = seasons[_seasonIndex].movies[_episodeIndex].title ?? ""
        if isFinded {
            let videoUrl = self.resolutions?[selectedQualityText]
            guard videoUrl != nil else{
                return
            }
            guard URL(string: videoUrl!) != nil else {
                return
            }
            if self.urlString != videoUrl!{
                self.changeUrl(url: videoUrl, title: "S\(_seasonIndex + 1)" + " " + "E\(_episodeIndex + 1)" + " \u{22}\(title)\u{22}")
            } else {
                print("ERROR")
            }
            return
        } else if !self.resolutions!.isEmpty {
            let videoUrl = Array(resolutions!.values)[0]
            self.changeUrl(url: videoUrl, title: "S\(_seasonIndex + 1)" + " " + "E\(_episodeIndex + 1)" + " \u{22}\(title)\u{22}")
            return
        }
    }
    
    func nextEpisode(seasonIndex: Int, episodeIndex: Int) {
        var resolutions: [String:String] = [:]
        var startAt :Int64?
        let episodeId : String = seasons[seasonIndex].movies[episodeIndex].id ?? ""
        if playerConfiguration.isMegogo {
            let parameters : [String:String] = ["video_id":episodeId,"access_token":self.playerConfiguration.megogoAccessToken]
            var success : MegogoStreamResponse?
            success = self.getMegogoStream(parameters: parameters,id: episodeId)
            if success != nil {
                
                resolutions[self.playerConfiguration.autoText] = success?.data.src
                success?.data.bitrates.forEach({ bitrate in
                    resolutions["\(bitrate.bitrate)p"] = bitrate.src
                })
                startAt = Int64(success?.data.playStartTime ?? 0)
                playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if playerConfiguration.isPremier {
            var success : PremierStreamResponse?
            success = self.getPremierStream(episodeId: episodeId)
            if success != nil {
                success?.fileInfo.forEach({ file in
                    if file.quality == "auto"{
                        resolutions[self.playerConfiguration.autoText] = file.fileName
                    } else {
                        resolutions["\(file.quality)"] = file.fileName
                    }
                })
                startAt = 0
                playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if !playerConfiguration.isMegogo && !playerConfiguration.isPremier {
            seasons[seasonIndex].movies[episodeIndex].resolutions.map { (key: String, value: String) in
                resolutions[key] = value
                startAt = 0
            }
            playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
        }
    }
}

extension VideoPlayerViewController: QualityDelegate, SpeedDelegate, EpisodeDelegate {
    
    func onEpisodeCellTapped(seasonIndex: Int, episodeIndex: Int) {
        var resolutions: [String:String] = [:]
        var startAt :Int64?
        let episodeId : String = seasons[seasonIndex].movies[episodeIndex].id ?? ""
        if playerConfiguration.isMegogo {
            let parameters : [String:String] = ["video_id":episodeId,"access_token":self.playerConfiguration.megogoAccessToken]
            var success : MegogoStreamResponse?
            success = self.getMegogoStream(parameters: parameters,id: episodeId)
            if success != nil {
                
                resolutions[self.playerConfiguration.autoText] = success?.data.src
                success?.data.bitrates.forEach({ bitrate in
                    resolutions["\(bitrate.bitrate)p"] = bitrate.src
                })
                startAt = Int64(success?.data.playStartTime ?? 0)
                self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if playerConfiguration.isPremier {
            var success : PremierStreamResponse?
            success = self.getPremierStream(episodeId: episodeId)
            if success != nil {
                success?.fileInfo.forEach({ file in
                    if file.quality == "auto"{
                        resolutions[self.playerConfiguration.autoText] = file.fileName
                    } else {
                        resolutions["\(file.quality)"] = file.fileName
                    }
                })
                startAt = 0
                self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if !playerConfiguration.isMegogo && !playerConfiguration.isPremier {
            seasons[seasonIndex].movies[episodeIndex].resolutions.map { (key: String, value: String) in
                resolutions[key] = value
                startAt = 0
            }
            self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
        }
    }
    
    func speedBottomSheet() {
        showSpeedBottomSheet()
    }
    func qualityBottomSheet() {
        showQualityBottomSheet()
    }
}
// 1277
