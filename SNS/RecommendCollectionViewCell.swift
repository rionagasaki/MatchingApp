//
//  RecommendCollectionViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/20.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {
    
    static public let identifier = "ColectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLabel :UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let reccomendImage:UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    public func configure(with model:Reccomend){
        self.nameLabel.text = model.text
        self.reccomendImage.image = UIImage.getImageByUrl(url: model.imageName)
    }
}
