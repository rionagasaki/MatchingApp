//
//  MyContentsCollectionViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/16.
//

import UIKit

class MyContentsCollectionViewCell: UICollectionViewCell {
    
    static public let identifier = "MyContentsCollectionViewCell"
    
    private let contentImage:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentImage.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
