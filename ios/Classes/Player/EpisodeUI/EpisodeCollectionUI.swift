//
//  EpisodeCollectionUI.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit
import TinyConstraints

protocol EpisodeDelegate{
    func onEpisodeCellTapped(seasonIndex : Int, episodeIndex : Int)
}

class EpisodeCollectionUI: UIViewController, BottomSheetCellDelegateSeason{
    
    var seasons = [Season]()
    var closeText : String = ""
    var seasonText : String = ""
    let videoPlayer = VideoPlayerViewController()
    var selectedSeasonIndex: Int = 0
    var delegate : EpisodeDelegate?
    
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
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EpisodeCollectionCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.moreColor
        return view
    }()
    
    var menuHeight = UIScreen.main.bounds.height
    var isPresenting = false
    
    var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var verticalStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .leading
        st.axis = .vertical
        st.distribution = .fill
        st.spacing = 20
        st.isUserInteractionEnabled = true
        st.backgroundColor = .clear
        st.translatesAutoresizingMaskIntoConstraints = true
        return st
    }()
    
    lazy var seasonSelectBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.setTitle("\(selectedSeasonIndex + 1) \(seasonText)", for: .normal)
        button.setImage(Svg.down.uiImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 16)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = .red
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(seasonSelectionTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Svg.exit.uiImage, for: .normal)
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if(UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight){
                menuHeight = UIScreen.main.bounds.width * 0.4
            } else {
                menuHeight = UIScreen.main.bounds.height * 0.4
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            menuHeight = UIScreen.main.bounds.height * 0.4
        }
        seasonSelectBtn.setTitle("\(selectedSeasonIndex + 1) \(seasonText)", for: .normal)
        
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            print("running on iPhone")
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            print("running on iPad")
        }
        
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        menuView.addSubview(verticalStack)
        verticalStack.addArrangedSubviews(topView , backView)
        backView.addSubview(collectionView)
        topView.addSubview(headerView)
        headerView.addSubview(seasonSelectBtn)
        seasonSelectBtn.backgroundColor = Colors.seasonColor
        headerView.addSubview(cancelBtn)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backdropView.addGestureRecognizer(tapGesture)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            seasonSelectBtn.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(132)
                make.left.equalTo(headerView)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            seasonSelectBtn.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(110)
                make.left.equalTo(headerView)
                make.centerY.equalToSuperview()
            }
        }
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.right.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerView.snp.makeConstraints { make in
                make.height.equalTo(topView)
                make.top.equalTo(topView).offset(0)
                make.left.equalTo(topView).offset(16)
                make.right.equalTo(topView).offset(-16)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            headerView.snp.makeConstraints { make in
                make.height.equalTo(topView)
                make.top.equalTo(topView).offset(0)
                make.left.equalTo(topView).offset(0)
                make.right.equalTo(topView).offset(-20)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            topView.snp.makeConstraints { make in
                make.width.equalTo(verticalStack)
                make.height.equalTo(verticalStack).multipliedBy(0.12)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            topView.snp.makeConstraints { make in
                make.width.equalTo(verticalStack)
                make.height.equalTo(verticalStack).multipliedBy(0.12)
                make.top.equalTo(verticalStack).offset(20)
            }
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            verticalStack.snp.makeConstraints { make in
                make.left.equalTo(menuView).offset(0)
                make.right.equalTo(menuView)
                make.bottom.equalTo(menuView).offset(-24)
                make.top.equalTo(menuView).offset(24)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            verticalStack.snp.makeConstraints { make in
                make.left.equalTo(menuView)
                make.right.equalTo(menuView).offset(-32)
                make.bottom.equalTo(menuView).offset(-30)
                make.top.equalTo(menuView)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc func tap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func seasonSelectionTapped() {
        let seasonVC = SeasonSelectionController()
        seasonVC.modalPresentationStyle = .overCurrentContext
        seasonVC.items = seasons
        seasonVC.closeText = closeText
        seasonVC.cellDelegate = self
        seasonVC.bottomSheetType = .season
        seasonVC.selectedIndex = selectedSeasonIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(seasonVC, animated: false, completion:nil)
        }
    }
    
    func updateSeasonNumber(index:Int) {
        videoPlayer.selectedSeason = index
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.snp.makeConstraints { make in
                make.width.equalTo(backView)
                make.height.equalTo(backView).multipliedBy(0.9)
                make.bottom.equalTo(backView)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.snp.makeConstraints { make in
                make.width.equalTo(backView)
                make.height.equalTo(backView)
                make.bottom.equalTo(backView)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backView.snp.makeConstraints { make in
                make.height.equalTo(verticalStack).multipliedBy(0.9)
                make.width.equalToSuperview()
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalToSuperview().offset(-30)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            backView.snp.makeConstraints { make in
                make.height.equalTo(verticalStack).multipliedBy(0.78)
                make.width.equalToSuperview()
                make.left.equalTo(50)
                make.right.equalTo(0)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone  {
            menuView.snp.makeConstraints { make in
                make.height.equalTo(menuHeight)
                make.bottom.equalToSuperview()
                make.right.left.equalToSuperview()
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            menuView.snp.makeConstraints { make in
                make.height.equalTo(menuHeight)
                make.bottom.equalToSuperview()
                make.right.left.equalToSuperview().inset(0)
            }
        }
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.snp.makeConstraints { make in
                make.height.equalTo(collectionView.snp_height).multipliedBy(0.5)
            }
        } else {
            collectionView.snp.makeConstraints { make in
                make.width.equalTo(collectionView.snp_width).multipliedBy(0.5)
            }
        }
    }
    
    func onBottomSheetCellTapped(index: Int, type: SeasonBottomSheetType) {
        videoPlayer.updateSeasonNum(index: index)
        selectedSeasonIndex = index
        seasonSelectBtn.setTitle("\(selectedSeasonIndex+1) сезон", for: .normal)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if(UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight){
                if(UIDevice.current.orientation.isLandscape){
                    menuHeight = UIScreen.main.bounds.width * 0.4
                } else {
                    menuHeight = UIScreen.main.bounds.height * 0.4
                }
            } else {
                menuHeight = UIScreen.main.bounds.height * 0.4
            }
        }
    }
}

extension EpisodeCollectionUI: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons[selectedSeasonIndex].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EpisodeCollectionCell
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 8
        cell.episodes = seasons[selectedSeasonIndex].movies[indexPath.row]
        let url = URL(string: seasons[selectedSeasonIndex].movies[indexPath.row].image ?? "")
        cell.episodeImage.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        let size = CGSize(width: safeFrame.width, height: safeFrame.height)
        return setCollectionViewItemSize(size: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onEpisodeCellTapped(seasonIndex: selectedSeasonIndex, episodeIndex: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    func setCollectionViewItemSize(size: CGSize) -> CGSize {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let width = (size.width - 1 * 12) / 2
            return CGSize(width: width, height: width)
        } else {
            let width = (size.width - 2 * 12) / 3
            return CGSize(width: width, height: width)
        }
    }
}

//MARK: Transition animation
extension EpisodeCollectionUI: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {
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
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
