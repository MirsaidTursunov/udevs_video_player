//
//  channelCollectionCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit
import SnapKit
import SDWebImage

class ChannelCollectionCell: UICollectionViewCell {
    static let identifier = "channelCollectionCell_identifier"
    
    var model : Channel? {
        didSet{
            checkSubForUI()
        }
    }
    
    lazy var lockUi: UIImageView = {
        let fadeBackground  = UIImageView()
        fadeBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        fadeBackground.layer.cornerRadius = 8
        fadeBackground.frame.size.height = 104
        fadeBackground.frame.size.width = 104
        
        let lock = IconButton()
        lock.setImage(Svg.lock.uiImage, for: .normal)
        lock.translatesAutoresizingMaskIntoConstraints = false
        fadeBackground.addSubview(lock)
        
        // MARK: center lock logo
        lock.leftAnchor.constraint(equalTo: fadeBackground.leftAnchor).isActive = true
        lock.rightAnchor.constraint(equalTo: fadeBackground.rightAnchor).isActive = true
        lock.topAnchor.constraint(equalTo: fadeBackground.topAnchor).isActive = true
        lock.bottomAnchor.constraint(equalTo: fadeBackground.bottomAnchor).isActive = true
        
        fadeBackground.isHidden = true
        return fadeBackground
    }()
    
    lazy var channelImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image.png")
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.addSubview(lockUi)
        return image
    }()
    
    
    

    private func checkSubForUI(){
        if (model!.hasAccess) {
            lockUi.isHidden = true
        }else{
            lockUi.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(channelImage)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    func setupUI(){
        channelImage.snp.makeConstraints { make in
            make.height.equalTo(104)
            make.width.equalTo(104)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stringToFloat(value : String) -> Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: value)
        let numberFloatValue = number?.floatValue
        return numberFloatValue ?? 0.0
    }
}
