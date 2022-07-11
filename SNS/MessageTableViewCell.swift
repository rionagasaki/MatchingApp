//
//  MessageTableViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/04.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let identifier = "MessageCell"
    static var heights:[CGFloat] = []
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(talker)
        contentView.addSubview(messageLabel)
        contentView.addSubview(profileIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        profileIcon.anchor(left: 15, right: 15, width: 60, height: 60)
//        messageLabel.anchor(top: <#T##NSLayoutYAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, left: <#T##NSLayoutXAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
//        talker.anchor(top: <#T##NSLayoutYAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, left: <#T##NSLayoutXAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
    }
    
    public func configure(with model:Message){
        messageLabel.text = model.message
        talker.text = model.talker
        profileIcon.image = model.profileIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let messageLabel:UILabel = {
       let label = UILabel()
        label.backgroundColor = .systemGreen
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let profileIcon:UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()
    
    private let talker:UILabel = {
       let label = UILabel()
        label.textColor = .white
        return label
    }()
}
