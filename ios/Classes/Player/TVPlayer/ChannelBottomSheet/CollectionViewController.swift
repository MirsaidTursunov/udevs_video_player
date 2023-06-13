//
//  CollectionViewController.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit
import SnapKit
import SDWebImage

protocol ChannelTappedDelegate{
    func onChannelTapped(channelIndex : Int)
}

class CollectionViewController: UIViewController {
    
    var collectionCellTitle: String?
    var collectionCellSubtitle: String?
    var collectionTimeLbl: String?
    var collectionCellImageText: String?
    var channelsCount: Int?
    var delegate : ChannelTappedDelegate?
    
    var channels = [Channels]()
    
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    public enum UIUserInterfaceIdiom : Int {
        case unspecified
        @available(iOS 3.2, *)
        case phone // iPhone and iPod touch style UI
        @available(iOS 3.2, *)
        case pad // iPad style UI
        @available(iOS 9.0, *)
        case tv // Apple TV style UI
        @available(iOS 9.0, *)
        case carPlay // CarPlay style UI
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(channelCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
        return collectionView
    }()
    let menuView = UIView()
    let menuHeight = UIDevice.current.userInterfaceIdiom == .pad ? 250 : UIScreen.main.bounds.height * 0.60
    var isPresenting = false
    
    var backView: UIView =  {
        let view = UIView()
        view.backgroundColor = Colors.mainColor
        return view
    }()
    
    var mainTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Телеканалы"
        label.textColor = .white
        return label
    }()
    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_exit",in: Bundle(for: SwiftUdevsVideoPlayerPlugin.self),compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = .clear
        return bdView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        
        view.addSubview(backdropView)
        view.addSubview(menuView)
        menuView.backgroundColor = Colors.backgroudColor
        menuView.addSubview(backView)
        backView.addSubview(collectionView)
        backView.addSubview(headerView)
        headerView.addSubview(mainTitle)
        headerView.addSubview(cancelBtn)
        menuView.backgroundColor = .clear
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backdropView.addGestureRecognizer(tapGesture)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            mainTitle.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(50)
                make.centerY.equalToSuperview()
            }
        } else {
            mainTitle.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }
        }
        
        
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.width.equalTo(backView).inset(16)
            make.centerX.equalTo(backView)
            make.height.equalTo(56)
            make.top.equalTo(backView)
        }
    }
    
    @objc func tap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(backView)
            make.bottom.equalTo(backView).offset(-30)
            make.height.equalTo(backView).multipliedBy(0.6)
        }
        
        menuView.snp.makeConstraints { make in
            make.height.equalTo(menuHeight)
            make.bottom.equalToSuperview().inset(0)
            make.right.left.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.left.right.equalTo(menuView)
            make.bottom.top.equalTo(menuView)
        }
    }
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.snp.makeConstraints { make in
                make.left.right.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(collectionView.snp_height).multipliedBy(0.5)
            }
        }else {
            collectionView.snp.makeConstraints { make in
                make.left.right.equalTo(view.safeAreaLayoutGuide)
                make.width.equalTo(collectionView.snp_width).multipliedBy(0.3)
            }
        }
    }
}
extension CollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! channelCollectionCell
        cell.backgroundColor = Colors.channels
        cell.layer.cornerRadius = 8
        cell.model = channels[indexPath.row]
        let time = channels[indexPath.row].remindedTime.floatValue
        let timeFormat = Int(time).secondsToTime()
        if (time == 0.0) {
            cell.timeLbl.text = "\(timeFormat)"
        }else {
            cell.timeLbl.text = "-\(timeFormat)"
        }
        let url = URL(string: channels[indexPath.row].logoImage)
        cell.channelImage.sd_setImage(with: url, completed: nil)
        cell.progressView.progress = stringToFloat(value: channels[indexPath.row].passedPercentage) / 100
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onChannelTapped(channelIndex: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    func stringToFloat(value : String) -> Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: value)
        let numberFloatValue = number?.floatValue
        return numberFloatValue ?? 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 126)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

//MARK: Transition animation
extension CollectionViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
