//
//  VideoFileViewController.swift
//  Stories
//
//  Created by Sunnatillo Shavkatov on 27/06/2022.
//

import UIKit

class StoryPlayerViewController: UIViewController {
    let video: Video
    let index: Int
    let storyButtonText: String
    weak var delegate: VideoPlayerDelegate?
    private var orientationLock = UIInterfaceOrientationMask.all
    let playerConfiguration: PlayerConfiguration
    
    let pagingController: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: [:]
    )
    
    init(video: Video, storyButtonText: String, index: Int, playerConfiguration: PlayerConfiguration) {
        self.video = video
        self.storyButtonText = storyButtonText
        self.index = index
        self.playerConfiguration = playerConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagingController()
        view.backgroundColor = .black
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipedUp(){
        let data:[String: Any] = ["slug": video.videoFiles[index].slug, "title": video.videoFiles[index].title, "story_link" : video.videoFiles[index].storyLink]
        if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                swipe(jsonString)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    private func configurePagingController() {
        let file = video.videoFiles[index] 
        
        let vc = configureFileViewController(with: file)
        pagingController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)

        pagingController.dataSource = self
        
        view.addSubview(pagingController.view)
        pagingController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        addChild(pagingController)
        pagingController.didMove(toParent: self)
    }
}

extension StoryPlayerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = (viewController as? FileViewController)?.file else { return nil }

        guard let index = video.videoFiles.firstIndex(where: {
            $0.id == viewController.id
        }) else { return nil }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let file = video.videoFiles[priorIndex]
        
        return configureFileViewController(with: file)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = (viewController as? FileViewController)?.file else { return nil }

        guard let index = video.videoFiles.firstIndex(where: {
            $0.id == viewController.id
        }) else { return nil }
        
        guard index < video.videoFiles.count - 1 else {
            return nil
        }
        
        let nextIndex = index + 1
        let file = video.videoFiles[nextIndex]
        
        return configureFileViewController(with: file)
    }
    
    private func configureFileViewController(with file: Story) -> UIViewController {
        let vc = FileViewController(file: file,playerConfiguration: playerConfiguration,index: index)
        vc.postDelegate = self
        vc.buttonText = self.storyButtonText
        vc.delegate = self.delegate
        return vc
    }
}

extension StoryPlayerViewController: FileViewControllerDelegate {
    
    func swipe(_ json: String) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        delegate?.close(args: json)
    }
    
    func didLongPress(_ vc: FileViewController, sender: UILongPressGestureRecognizer) {
        if sender.state == .began ||  sender.state == .ended {
            if(sender.state == .began) {
                vc.player?.pause()
            } else {
                vc.player?.play()
            }
        }
    }
    
    func close() {
        delegate?.close(args: nil)
        dismiss(animated: true)
        return
    }
    
    func didTap(_ vc: FileViewController, sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: view)
        
        if touchLocation.x < view.center.x {
            guard let previousVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerBefore: vc) else {
                vc.player?.seek(to: .zero)
                return
            }
            pagingController.setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
        } else {
            guard let nextVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerAfter: vc) else {
                dismiss(animated: true)
                return
            }
            pagingController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func videoEnded(_ vc: FileViewController) {
        guard let nextVC = pagingController.dataSource?.pageViewController(pagingController, viewControllerAfter: vc) else {
            dismiss(animated: true)
            return
        }
        pagingController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
}
