//
//  TableViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/02.
//

import UIKit

class AccountSettingCell: UITableViewCell {

    static let identifier = "AccountSettingCell"
        
        private let iconContainer:UIView = {
            let view = UIView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
        
        private let label:UILabel = {
           let label = UILabel()
            label.textColor = .white
            return label
        }()
        
        private let detail:UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "chevron.right")?.withTintColor(UIColor.white)
            return imageView
        }()
        
        
        private let iconImageView:UIImageView = {
           let imageView = UIImageView()
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(label)
            contentView.addSubview(iconContainer)
            contentView.addSubview(detail)
            iconContainer.addSubview(iconImageView)
            contentView.clipsToBounds = true
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let size = contentView.frame.size.height - 12
            iconContainer.frame = CGRect(x: 10, y: 6, width: size, height: size)
        
            let imageSize = size/1.5
            iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (iconContainer.frame.size.height/2)-(imageSize/2), width: imageSize, height: imageSize)
            label.frame = CGRect(x: 15+iconContainer.frame.size.width,
                                 y: 0,
                                 width: contentView.frame.width-15-iconContainer.frame.size.width,
                                 height: contentView.frame.size.height)
            detail.frame = CGRect(x: contentView.frame.width-30, y: (contentView.frame.height/2)-8, width: 16, height: 16)
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
            label.text = nil
            iconContainer.backgroundColor = nil
        }
        
        public func configure(with model: SettingOption){
            label.text = model.title
            iconImageView.image = model.iconImage
            iconContainer.backgroundColor = model.iconBackground
        }
    
}
