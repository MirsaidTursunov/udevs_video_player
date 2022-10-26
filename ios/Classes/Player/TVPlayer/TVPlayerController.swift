//
//  TVPlayerController.swift
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
import Flutter

protocol TVQualityDelegate {
    func qualityBottomSheet()
}
protocol TVSpeedDelegate {
    func speedBottomSheet()
}

protocol TVVideoPlayerDelegate: AnyObject {
    func getDuration(duration: Double)
}

class TVVideoPlayerViewController: UIViewController, SettingsBottomSheetCellDelegate, BottomSheetCellDelegate {
    
    private var speedList = ["0.25","0.5","0.75","1.0"].sorted()
    private var player = AVPlayer()
    private var playerLayer =  AVPlayerLayer()
    private var playerItemContext = 0
    weak var delegate: VideoPlayerDelegate?
    var urlString: String?
    var qualityLabelText = ""
    var speedLabelText = ""
    var showsBtnText = ""
    var liveLabelText = ""
    var startPosition: Int?
    var programs : [ProgramsInfo] = [ProgramsInfo]()
    var titleText: String?
    var isRegular: Bool = false
    var resolutions: [String:String]?
    var qualityText = "Auto"
    private var swipeGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    private var tapHideGesture: UITapGestureRecognizer!
    private var panDirection = SwipeDirection.vertical
    private var isVolume = false
    private var selectedSpeedText = "1.0x"
    private var volumeViewSlider: UISlider!
    private var timer: Timer?
    private var seekForwardTimer: Timer?
    private var seekBackwardTimer: Timer?
    private var playerRate = 1.0
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private var durationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private var leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private var liveTextLabel: UILabel = {
        let label = UILabel()
        label.text = "LIVE"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label;
    }()
    
    private var liveCircle: UIView = {
        let circle = UIView(frame: CGRect(x:6,y:5,width: 12, height: 12))
        circle.layer.cornerRadius = (circle.frame.size.width) / 2
        circle.backgroundColor = .red
        let newCircle = UIView()
        newCircle.addSubview(circle)
        return newCircle
    }()
    
    private lazy var liveStackView: UIStackView = {
        let liveView = UIStackView(arrangedSubviews: [liveCircle, liveTextLabel])
        liveView.height(20)
        liveView.sizeToFit()
        liveView.axis = .horizontal
        liveView.distribution = .equalSpacing
        return liveView
    }()
    
    private lazy var showsBtnStackView: UIStackView = {
        let liveView = UIStackView(arrangedSubviews: [showsBtn])
        liveView.axis = .horizontal
        return liveView
    }()
    
    private var seperatorLabel: UILabel = {
        let label = UILabel()
        label.text = " / "
        label.textColor = .white
        label.font = label.font.withSize(15)
        return label
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
        let stackView = UIStackView(arrangedSubviews: [showsBtn])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - BottomSheets
    
    func speedBottomSheet() {
        showSpeedBottomSheet()
    }
    func qualityBottomSheet() {
        showQualityBottomSheet()
    }
    
    func showQualityBottomSheet(){
        let resList = resolutions ?? ["480p" : urlString!]
        let array = Array(resList.keys)
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.items = array.sorted().reversed()
        bottomSheetVC.labelText = qualityLabelText
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.bottomSheetType = .quality
        bottomSheetVC.selectedIndex = array.firstIndex(of: qualityText) ?? 0
        debugPrint("SELECTED INDEX \( bottomSheetVC.selectedIndex)")
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
        slider.value = 1
        slider.tintColor = Colors.mainColor
        slider.maximumTrackTintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.exit.uiImage, for: .normal)
        button.tintColor = .white
        button.size(CGSize(width: 32, height: 32))
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
    
    private var showsBtn: UIButton = {
        let button = UIButton()
        button.setImage(Svg.programmes.uiImage, for: .normal)
        button.setTitle("Телепередачи", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        button.imageEdgeInsets = UIEdgeInsets(top: Constants.bottomViewButtonInset, left: 0, bottom: Constants.bottomViewButtonInset, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.isHidden = false
        
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
    
    
    func setupDataSource(title:String?, urlString: String?, startAt  : Int64?){
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        let urlAsset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: urlAsset)
        player.automaticallyWaitsToMinimizeStalling = true
        player.replaceCurrentItem(with: playerItem)
        
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        addTimeObserver(titleLabel: titleLabel, title: titleText ?? "")
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        selectedAudioTrack = player.currentItem?.selected(type: .audio) ?? "None"
        selectedSubtitle = player.currentItem?.selected(type: .subtitle) ?? "None"
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(40000)
        player.automaticallyWaitsToMinimizeStalling = true;
        player.seek(to:CMTimeMakeWithSeconds(Float64(Float(startAt ?? 0)),preferredTimescale: 1000))
        player.play()
        if let titleText = title {
            titleLabel.text = titleText
        }
    }
    
    @objc func changeOrientation(_ sender: UIButton){
        var value  = UIInterfaceOrientation.landscapeRight.rawValue
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            value = UIInterfaceOrientation.portrait.rawValue
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
    
    private var landscapeButton: UIButton = {
        let button = UIButton()
        if(UIDevice.current.orientation.isLandscape){
            button.setImage(Svg.horizontal.uiImage, for: .normal)
        } else {
            button.setImage(Svg.portrait.uiImage, for: .normal)
        }
        button.addTarget(self, action: #selector(changeOrientation(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showsBtn.setTitle(showsBtnText, for: .normal)
        view.backgroundColor = .black
        if #available(iOS 13.0, *) {
            let value = UIInterfaceOrientationMask.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
        }
        
        if #available(iOS 13.0, *) {
            setSliderThumbTintColor(Colors.mainColor)
        } else {
            timeSlider.thumbTintColor = Colors.mainColor
        }
        
        addSubviews()
        pinchGesture()
        bottomView.clipsToBounds = true
        timeSlider.clipsToBounds = true
        addConstraints()
        addGestures()
        playButton.alpha = 0.0
        activityIndicatorView.startAnimating()
        setupDataSource(title: titleText, urlString: urlString,startAt: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        resetTimer()
        configureVolume()
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
            if #available(iOS 16.0, *) {
                landscapeButton.setImage(Svg.horizontal.uiImage, for: .normal)
                addVideosLandscapeConstraints()
            } else {
                landscapeButton.setImage(Svg.portrait.uiImage, for: .normal)
                addVideoPortaitConstraints()
            }
        } else {
            if #available(iOS 16.0, *) {
                landscapeButton.setImage(Svg.portrait.uiImage, for: .normal)
                addVideoPortaitConstraints()
            } else {
                landscapeButton.setImage(Svg.horizontal.uiImage, for: .normal)
                addVideosLandscapeConstraints()
            }
        }
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
        view.addSubview(activityIndicatorView)
        overlayView.addSubview(bottomView)
        overlayView.addSubview(landscapeButton)
        addTopViewSubviews()
        addBottomViewSubviews()
    }
    
    //MARK: - addBottomViewSubviews
    func addBottomViewSubviews() {
        bottomView.addSubview(seperatorLabel)
        bottomView.addSubview(timeSlider)
        bottomView.addSubview(liveTextLabel)
        bottomView.addSubview(liveCircle)
        bottomView.addSubview(showsBtn)
        bottomView.addSubview(liveStackView)
        bottomView.addSubview(showsBtnStackView)
        bottomView.addSubview(timeStackView)
    }
    
    func addTopViewSubviews() {
        topView.addSubview(exitButton)
        topView.addSubview(titleLabel)
        topView.addSubview(settingsButton)
    }
    
    func addConstraints() {
        addVideosLandscapeConstraints()
        addBottomViewConstraints()
        addTopViewConstraints()
        addControlButtonConstraints()
    }
    
    func addControlButtonConstraints(){
        playButton.center(in: view)
        playButton.width(Constants.controlButtonSize)
        playButton.height(Constants.controlButtonSize)
        playButton.layer.cornerRadius = Constants.controlButtonSize/2
        activityIndicatorView.center(in: view)
        activityIndicatorView.layer.cornerRadius = 20
    }
    
    func addBottomViewConstraints() {
        var bottomPad: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            bottomPad = 5
        } else {
            bottomPad = -5
        }
        
        bottomView.leading(to: view.safeAreaLayoutGuide, offset: Constants.horizontalSpacing)
        bottomView.trailing(to: view.safeAreaLayoutGuide, offset: -Constants.horizontalSpacing)
        bottomView.bottom(to: view.safeAreaLayoutGuide, offset: 10)
        bottomView.height(70)
        
        liveStackView.bottomToTop(of: timeStackView, offset: -1)
        liveStackView.spacing = 24
        liveStackView.leftToSuperview(offset: 8)
        
        timeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        showsBtn.width(140)
        showsBtn.snp.makeConstraints{ make in
            make.right.equalTo(landscapeButton).offset(-12)
        }
        showsBtnStackView.bottomToTop(of: timeSlider, offset: 8)
        showsBtn.layer.cornerRadius = 8
        
        landscapeButton.bottomToTop(of: timeSlider, offset: 0)
        landscapeButton.snp.makeConstraints { make in
            make.right.equalTo(bottomView).offset(-16)
        }
    }
    
    private var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.more.uiImage, for: .normal)
        button.layer.zPosition = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        button.imageEdgeInsets = UIEdgeInsets(top: Constants.bottomViewButtonInset, left: 0, bottom: Constants.bottomViewButtonInset, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingPressed(_ :)), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    @objc func settingPressed(_ sender: UIButton) {
        let vc = TVSettingVC()
        vc.modalPresentationStyle = .custom
        vc.delegete = self
        vc.speedDelegate = self
        vc.settingModel = [
            SettingModel(leftIcon: Svg.settings.uiImage, title: speedLabelText, configureLabel:  selectedSpeedText),
            SettingModel(leftIcon:Svg.playSpeed.uiImage, title: qualityLabelText, configureLabel: qualityText)
        ]
        self.present(vc, animated: true, completion: nil)
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
        // exit
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
    
    func addVideosLandscapeConstraints() {
        portraitConstraints.deActivate()
        landscapeConstraints.append(contentsOf: videoView.edgesToSuperview())
    }
    func addVideoPortaitConstraints() {
        landscapeConstraints.deActivate()
        let width = view.frame.width
        let heigth = width * 9 / 16
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
        let circleImage = makeCircleWith(size: CGSize(width: 20, height: 20),
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
    
    @objc func qualitySelectionButtonPressed(_ sender: UIButton){
        showQualityBottomSheet()
    }
    
    @objc func speedButtonPressed(_ sender: UIButton){
        showSpeedBottomSheet()
    }
    
    @objc func action() {
        let vc = ProgramViewController()
        vc.modalPresentationStyle = .custom
        vc.programInfo = self.programs
        vc.menuHeight = self.programs.isEmpty ? 250 : UIScreen.main.bounds.height * 0.75
        if !(vc.programInfo.isEmpty) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func exitButtonPressed(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
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
        sender.value=1;
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationTimeLabel.text = getTimeString(from: player.currentItem!.duration)
        }
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing{
                        self?.playButton.setImage(Svg.pause.uiImage, for: .normal)
                        self?.playButton.alpha = self?.skipBackwardButton.alpha ?? 0.0
                        self?.activityIndicatorView.stopAnimating()
                        self?.enableGesture = true
                    } else if newStatus == .paused {
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
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
    
    //MARK: - Time logic
    func addTimeObserver(titleLabel: UILabel, title: String) {
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
            let time = CMTimeMake(value: Int64(remainTime), timescale: 1)
            self?.leftTimeLabel.text = "-\(self?.getTimeString(from: time) ?? "00:00")"
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
            overlayView.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            bottomView.alpha = alpha
        }, completion: nil)
    }
    
    @objc func hideSeekForwardButton() {
        if topView.alpha == 0 {
            let options: UIView.AnimationOptions = [.curveEaseIn]
            UIView.animate(withDuration: 0.1, delay: 0.1, options: options, animations: {[self] in
                let alpha = 0.0
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
    
    func showControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.2, delay: 0.2, options: options, animations: {[self] in
            let alpha = 1.0
            topView.alpha = alpha
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
    
    // settings bottom sheet tapped
    func onSettingsBottomSheetCellTapped(index: Int) {
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            showSubtitleBottomSheet()
            break
        case 3:
            showAudioTrackBottomSheet()
            break
        default:
            break
        }
    }
    
    //MARK: - Bottom Sheets Configurations
    // bottom sheet tapped
    func onBottomSheetCellTapped(index: Int, type : BottomSheetType) {
        switch type {
        case .quality:
            let resList = resolutions ?? ["480p":urlString!]
            let array = Array(resList.keys)
            self.qualityText = array[index]
            let url = resList[array[index]]
            guard let videoURL = URL(string: url ?? "") else {
                return
            }
            let currentTime = self.player.currentTime()
            let asset = AVURLAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.seek(to: currentTime)
            self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(1)
            self.player.automaticallyWaitsToMinimizeStalling = true;
            break
        case .speed:
            self.playerRate =  Double(speedList[index])!
            self.selectedSpeedText = isRegular  ? "\(self.playerRate)x" : "\(self.playerRate)x"
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
    
    private func showAudioTrackBottomSheet(){
        var audios = player.currentItem?.tracks(type: .audio) ?? ["None"]
        if audios.isEmpty {
            audios = ["Auto"]
            selectedAudioTrack = "Auto"
        }
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.items = audios
        bottomSheetVC.labelText = "Аудио"
        bottomSheetVC.bottomSheetType = .audio
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.selectedIndex = audios.firstIndex(of: selectedAudioTrack) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
    
    private func showSubtitleBottomSheet(){
        var subtitles = player.currentItem?.tracks(type: .subtitle) ?? ["None"]
        subtitles.insert("None", at: 0)
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.items = subtitles
        bottomSheetVC.labelText = "Субтитле"
        bottomSheetVC.bottomSheetType = .subtitle
        bottomSheetVC.selectedIndex = subtitles.firstIndex(of: selectedSubtitle) ?? 0
        bottomSheetVC.cellDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
}
extension TVVideoPlayerViewController:  ChannelTappedDelegate, TVQualityDelegate, TVSpeedDelegate {
    func onChannelTapped(channelIndex: Int) {
        //        let startAt :Int64 = 0
        //        self.setupDataSource(title: "", urlString: channels[channelIndex].url, startAt: startAt)
        //        print("Channel URL -> \(channels[channelIndex].url) Index \(channelIndex)")
    }
}
// 1409
