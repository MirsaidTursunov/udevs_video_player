//
//  EpisodeItemCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit
import SnapKit

class EpisodeCollectionCell: UICollectionViewCell {
    
    var episodes : Movie? {
        didSet {
            titleLbl.text = episodes?.title ?? ""
            durationLbl.text = VGPlayerUtils.getTimeIntString(from: episodes?.duration ?? 0)
        }
    }
    
    var containerStack: UIView = {
        let st = UIView()
        st.backgroundColor = .clear
        return st
    }()
    
    var episodeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image.png")
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    var playIcon: UIImageView = {
        let image = UIImageView()
        image.image = Svg.serialPlay.uiImage
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        return image
    }()
    
    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = episodes?.title
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 15 , weight: .semibold)
        return label
    }()
    
   lazy var durationLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = VGPlayerUtils.getTimeIntString(from: episodes?.duration ?? 0)
        label.textColor = UIColor(rgb: 0xFF9D9D9D)
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 11,weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
            super.init(frame: .zero)
        contentView.addSubview(containerStack)
        contentView.backgroundColor = .clear
        setupUI()
    }
        
    func setupUI(){
        containerStack.addSubview(episodeImage)
        containerStack.addSubview(titleLbl)
        containerStack.addSubview(durationLbl)
        episodeImage.addSubview(playIcon)
        playIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalTo(episodeImage)
            make.centerX.equalTo(episodeImage)
        }
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        episodeImage.top(to: containerStack)
        episodeImage.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(containerStack)
        }
        titleLbl.topToBottom(of: episodeImage, offset: 4)
        titleLbl.snp.makeConstraints { make in
            make.left.right.equalTo(containerStack)
        }
        durationLbl.topToBottom(of: titleLbl, offset: 2)
        durationLbl.snp.makeConstraints { make in
            make.left.right.equalTo(containerStack).offset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    func addArrangedSubviewss(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
