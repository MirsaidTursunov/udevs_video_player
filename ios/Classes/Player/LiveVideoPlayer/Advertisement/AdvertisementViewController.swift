//
//  AdvertisementViewController.swift
//  CocoaLumberjack
//
//  Created by Abdurahmon on 19/07/2024.
//

import Foundation

class AdvertisementViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        let uiView = UIView()
        uiView.frame = CGRect(x: 50,y: 50,width: 200,height: 200)
        uiView.backgroundColor = UIColor.magenta
        let text = UILabel()
        text.text = "Sample Text"
        text.textColor = UIColor.blue
        text.textAlignment = .center
        uiView.addSubview(text)
        view.addSubview(uiView)
    }
    
}
