//
//  ChatTableViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/04.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    static let identifier = "ChatCell"
    
    private let groupIcon:UIImageView = {
       let imageView = UIImageView()
        let image = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.darkGray))
        image.tintColor = .darkGray
        image.backgroundColor = .systemGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.systemGray4.cgColor
        return imageView
    }()
    
    private let groupTitle:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let messageLabel:UILabel = {
       let label = UILabel()
        label.textColor = .systemGray3
        return label
    }()
    
    private let notifyBudge:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemPink
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(groupIcon)
        contentView.addSubview(groupTitle)
        contentView.addSubview(messageLabel)
        contentView.addSubview(notifyBudge)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 22
        let half = contentView.frame.size.width/1.5
        let littleSize = contentView.frame.size.height/2
        let imageSize = size/1.2
        groupIcon.frame = CGRect(x:(size-imageSize)/2, y: (contentView.frame.size.height/2)-size/2, width: size, height: size)
        groupTitle.frame = CGRect(x: groupIcon.right+littleSize, y:5, width: groupTitle.intrinsicContentSize.width, height: groupTitle.intrinsicContentSize.height)
        messageLabel.frame = CGRect(x: groupIcon.right+littleSize, y: groupTitle.bottom+7, width:half , height: messageLabel.intrinsicContentSize.height)
        notifyBudge.frame = CGRect(x: contentView.frame.width-60, y: (contentView.frame.height/2)-((notifyBudge.intrinsicContentSize.height+6)/2), width: notifyBudge.intrinsicContentSize.width+15, height: notifyBudge.intrinsicContentSize.height+6)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupIcon.image = nil
        groupTitle.text = nil
        messageLabel.text = nil
        notifyBudge.text = nil
    }
    
    public func configure(with model: Chat){
        groupTitle.text = model.title
        groupIcon.image = model.groupIcon
        messageLabel.text = model.message
        notifyBudge.text = String(model.notifyNum)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
