import UIKit

class MyCardsCollectionViewCell: UICollectionViewCell {
    
    static public let identifier = "MyCardsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let postImage:UIImageView = {
       let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
}

