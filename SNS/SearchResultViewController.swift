//
//  SearchResultViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

   static public let identifier = "Search_Result_Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: 10, y: (contentView.frame.height/2) - 40, width: 80, height: 80)
        iconImageView.layer.cornerRadius = iconImageView.frame.height/2
        usernameLabel.frame = CGRect(x: iconImageView.right+10, y: (contentView.height/2) - usernameLabel.intrinsicContentSize.height/2, width: usernameLabel.intrinsicContentSize.width, height: usernameLabel.intrinsicContentSize.height)
    }

    public func config(model:SearchResult){
        usernameLabel.text = model.username
        iconImageView.image = UIImage.getImageByUrl(url: model.profileImage) 
    }
    
    private let iconImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
}
