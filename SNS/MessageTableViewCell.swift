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
        MessageTableViewCell.heights = []
        profileIcon.frame = CGRect(x: contentView.frame.size.width/30, y:(contentView.frame.size.height/2)-15, width: 30, height:30)
        if messageLabel.intrinsicContentSize.width > 150 {
            let height = messageLabel.intrinsicContentSize.width/150
            let size = messageLabel.intrinsicContentSize.width/height
            messageLabel.frame = CGRect(x: profileIcon.right+10, y: (contentView.frame.height/2)-((messageLabel.intrinsicContentSize.height+20)/2), width:size+50, height: ((messageLabel.intrinsicContentSize.height)*height)+20)
        }else{
        messageLabel.frame = CGRect(x: profileIcon.right+10, y: (contentView.frame.height/2)-((messageLabel.intrinsicContentSize.height+20)/2), width:messageLabel.intrinsicContentSize.width+25, height: messageLabel.intrinsicContentSize.height+20)
        }
        messageLabel.clipsToBounds = true
        messageLabel.layer.cornerRadius = 18
        profileIcon.clipsToBounds = true
        profileIcon.layer.cornerRadius = profileIcon.frame.width/2
        MessageTableViewCell.heights.append(messageLabel.frame.height)
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
