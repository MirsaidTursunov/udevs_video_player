//
//  channelCollectionCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit
import SnapKit
import SDWebImage

class channelCollectionCell: UICollectionViewCell {
    
//    var model : Channel? {
//        didSet{
//            cellTitle.text = model?.title
//            subtitle.text = model?.subtitle
//            timeLbl.text = model?.remindedTime
//            progressView.progress = stringToFloat(value: model?.passedPercentage ?? "")
//        }
//    }
    
    var model : Channel? {
        didSet{
            cellTitle.text = nil
            subtitle.text = nil
            timeLbl.text = nil
            progressView.progress = 0.0
        }
    }
    lazy  var channelImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image.png")
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    lazy var cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        return label
    }()
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    lazy  var timeLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.tintColor = .yellow
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progress = 0.0
        return view
    }()
    var verticalStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .leading
        st.axis = .vertical
        st.distribution = .fill
        st.spacing = 6
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    var horizontalStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .center
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.spacing = 12
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    var horizontalStack2: UIStackView = {
        let st = UIStackView()
        st.alignment = .center
        st.axis = .horizontal
        st.distribution = .fill
        st.spacing = 10
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    var containerStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .leading
        st.axis = .vertical
        st.distribution = .fill
        st.spacing = 11
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(containerStack)
        contentView.backgroundColor = .clear
        verticalStack.addArrangedSubviews(cellTitle,subtitle)
        horizontalStack.addArrangedSubviews(channelImage,verticalStack)
        horizontalStack2.addArrangedSubviews(progressView,timeLbl)
        containerStack.addArrangedSubviews(horizontalStack,horizontalStack2)
        setupUI()
    }
    
    func setupUI(){
        
        channelImage.snp.makeConstraints { make in
            make.width.height.equalTo(56)
        }
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 16, left: 16,bottom: 16, right: 16))
            make.width.equalToSuperview()
        }
        timeLbl.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.right.equalTo(containerStack).inset(-10)
        }
        cellTitle.snp.makeConstraints { make in
            make.width.equalTo(horizontalStack2)
        }
        subtitle.snp.makeConstraints { make in
            make.width.equalTo(horizontalStack2)
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
