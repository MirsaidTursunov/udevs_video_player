//
//  ProgramCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit

class ProgramCell: UITableViewCell {
    
    var programModel : Programms?{
        didSet{
            timeLB.text = programModel?.scheduledTime
            channelNamesLB.text = programModel?.programTitle
        }
    }
    var containerStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .center
        st.axis = .horizontal
        st.distribution = .fill
        st.spacing = 16
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    var hStack: UIStackView = {
        let st = UIStackView()
        st.alignment = .center
        st.axis = .horizontal
        st.distribution = .fill
        st.spacing = 8
        st.isUserInteractionEnabled = false
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
   lazy var timeLB: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = Colors.textColor
        return label
    }()
    
   lazy var channelNamesLB: UILabel = {
        let label = UILabel()
        label.text = programModel?.programTitle
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.sizeToFit()
        label.clipsToBounds = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
     var liveCircle: UIView = {
        let circle = UIView(frame: CGRect(x:6,y:5,width: 10, height: 10))
        circle.layer.cornerRadius = (circle.frame.size.width) / 2
        circle.backgroundColor = Colors.green
        return circle
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        self.backgroundColor =  .clear
        
        setUp()
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0))
            make.width.equalToSuperview()
        }
        
//        timeLB.snp.makeConstraints { make in
////            make.width.equalTo(50)
//        }
        liveCircle.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
    }
    
    func setUp() {
        contentView.addSubview(containerStack)
        containerStack.addArrangedSubviews(
            timeLB,
            hStack
        )
        
        hStack.addArrangedSubviews(
            liveCircle,
            channelNamesLB
        )
    }
}
extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
