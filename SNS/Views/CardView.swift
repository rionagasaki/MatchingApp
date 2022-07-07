import UIKit
import FirebaseFirestore

class CardView: UIView {
    
    private let cardImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "live")
        return imageView
    }()
    
    private let eventName:UILabel = {
       let label = UILabel()
       label.font = .boldSystemFont(ofSize: 40)
       label.text = "backnumber"
       label.adjustsFontSizeToFitWidth = true
       label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.sizeToFit()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0.5
       return label
    }()
    
    private let dateLabel:UILabel = {
       let label = UILabel()
       label.font = .boldSystemFont(ofSize: 15)
       label.text = "日時：6/30 13:00~"
        
        label.textColor = .black
       return label
    }()
    
    private let placeLabel:UILabel = {
       let label = UILabel()
       label.font = .boldSystemFont(ofSize: 15)
       label.text = "場所：横浜アリーナ"
        
        label.textColor = .black
       return label
    }()
    
    
    private let personNumber:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "人数：3人"
        label.textColor = .black
        return label
    }()
    private let ownerName:UILabel = {
        let label = UILabel()
        label.text = "オーナー名：JohnLenon"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
         label.textAlignment = .center
         label.backgroundColor = .systemBlue
         label.sizeToFit()
         label.layer.cornerRadius = 10
         label.clipsToBounds = true
         label.alpha = 0.5
        return label
    }()
    
    private let ownerImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sample")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemGray
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        return imageView
    }()
    let goodLabel: UILabel = {
           let lable = UILabel()
            lable.font = .boldSystemFont(ofSize: 45)
            lable.text = "GOOD"
            lable.textColor = .systemGreen
            
            lable.layer.borderWidth = 3
            lable.layer.borderColor = UIColor.systemGreen.cgColor
            lable.layer.cornerRadius = 10
            
            lable.textAlignment = .center
            lable.alpha = 0
            return lable
        }()
        
        let nopeLabel: UILabel = {
           let lable = UILabel()
            lable.font = .boldSystemFont(ofSize: 45)
            lable.text = "NOPE"
            lable.textColor = .systemRed
            
            lable.layer.borderWidth = 3
            lable.layer.borderColor = UIColor.systemRed.cgColor
            lable.layer.cornerRadius = 10
            
            lable.textAlignment = .center
            lable.alpha = 0
            return lable
        }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        addSubview(cardImageView)
        addSubview(eventName)
        addSubview(goodLabel)
        addSubview(nopeLabel)
        addSubview(ownerImage)
        addSubview(dateLabel)
        addSubview(placeLabel)
        addSubview(personNumber)
        addSubview(ownerName)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCardGesture))
        self.addGestureRecognizer(panGesture)
        cardImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        
        eventName.frame = CGRect(x: (frame.width/2)-(eventName.frame.width/2), y: cardImageView.bottom+10, width:eventName.intrinsicContentSize.width+20, height: eventName.intrinsicContentSize.height+10)
        
        ownerImage.frame = CGRect(x: eventName.left, y: eventName.bottom + 20, width: 30, height: 30)
        ownerName.frame = CGRect(x: ownerImage.right+10, y: eventName.bottom + 20, width: ownerName.intrinsicContentSize.width+10, height: ownerName.intrinsicContentSize.height+10)
        dateLabel.frame = CGRect(x: eventName.left, y: ownerName.bottom+5, width: dateLabel.intrinsicContentSize.width+10, height: dateLabel.intrinsicContentSize.height+10)
        placeLabel.frame = CGRect(x: eventName.left, y: dateLabel.bottom+5, width: placeLabel.intrinsicContentSize.width+10, height: placeLabel.intrinsicContentSize.height+10)
        personNumber.frame = CGRect(x: eventName.left, y: placeLabel.bottom+5, width: personNumber.intrinsicContentSize.width+10, height: personNumber.intrinsicContentSize.height+10)
        goodLabel.frame = CGRect(x: 30, y: 400, width: 300, height: 50)
        nopeLabel.frame = CGRect(x: 30, y: 400, width: 300, height: 50)
    }
    
    @objc private func panCardGesture(gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.handlePanChange(translation: translation)
        }else if gesture.state == .ended{
            self.handlePanEnded()
        }
    }
    
    private func handlePanChange(translation:CGPoint){
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let degree:CGFloat = translation.x / 20
        let angle = degree * .pi / 100
        
        let rotateTranslation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotateTranslation.translatedBy(x: translation.x, y: translation.y)
               
               let ratio: CGFloat = 1 / 100
               let ratioValue = ratio * translation.x
               
               if translation.x > 0 {
                   self.goodLabel.alpha = ratioValue
               } else if translation.x < 0 {
                   self.nopeLabel.alpha = -ratioValue
               }
    }
    private func handlePanEnded() {
           UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
               self.transform = .identity
               self.layoutIfNeeded()
               self.goodLabel.alpha = 0
               self.nopeLabel.alpha = 0
           }
       }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


