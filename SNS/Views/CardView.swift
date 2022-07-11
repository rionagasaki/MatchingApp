import UIKit
import FirebaseFirestore
import Cosmos
import CoreGraphics

class CardView: UIView {
    
    private let cardImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let cosmos:CosmosView = {
        let cosmos = CosmosView()
        cosmos.settings.filledImage = UIImage(named: "GoldStar")
        cosmos.settings.emptyImage = UIImage(named: "EmptyImage")
        cosmos.settings.updateOnTouch = false
        return cosmos
    }()
    
    private let eventName:UILabel = {
       let label = UILabel()
       label.font = .boldSystemFont(ofSize: 30)
       label.adjustsFontSizeToFitWidth = true
       label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.1)
        label.textAlignment = .center
        label.sizeToFit()
       return label
    }()
    
    private let appealTextView:UITextView = {
       let textView = UITextView()
        textView.clipsToBounds = true
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.cornerRadius = 20
        textView.isEditable = false
        textView.isHidden = true
        return textView
    }()
    
    private let backView:UIView = {
       let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let dateLabel:UIButton = {
       let label = UIButton()
        label.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        label.tintColor = .white
        label.setTitle("8-13 13:00~", for: .normal)
        label.configuration?.imagePadding = CGFloat(20)
       return label
    }()
    
    private let placeLabel:UIButton = {
       let label = UIButton()
        label.setImage(UIImage(systemName: "map"), for: .normal)
        label.tintColor = .white
        label.setTitle("新宿駅", for: .normal)
        label.configuration?.imagePadding = CGFloat(20)
       return label
    }()
    
    
    
    private let ownerName:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
         label.textAlignment = .center
         label.sizeToFit()
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
    
    private let detail:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let tagLabel :UIButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
       return button
    }()

    private let endDetail:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.isEnabled = false
        return button
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
        
    init(model:cardData) {
        super.init(frame: .zero)
        subView()
        configure(with: model)
        detail.addTarget(self, action: #selector(didTouchDetail), for: .touchUpInside)
        endDetail.addTarget(self, action: #selector(hideDetail), for: .touchUpInside)
    }
    
    private func subView(){
        
        
        addSubview(cardImageView)
        cardImageView.addSubview(backView)
        cardImageView.addSubview(tagLabel)
        addSubview(endDetail)
        addSubview(eventName)
        addSubview(cosmos)
        addSubview(appealTextView)
        addSubview(goodLabel)
        addSubview(nopeLabel)
        addSubview(ownerImage)
        addSubview(dateLabel)
        addSubview(placeLabel)
        addSubview(ownerName)
        addSubview(detail)
    }
    
    @objc func didTouchDetail(){
        if detail.currentImage == UIImage(systemName: "chevron.up"){
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.backView.center.y = self.cardImageView.top + self.backView.height/2
                self.eventName.center.y = self.cardImageView.top + 10 + self.eventName.height/2
                self.detail.center.y = self.cardImageView.top+10 + self.eventName.height/2
                self.cosmos.center.y = self.eventName.bottom + 10
                self.appealTextView.center.y = self.cosmos.bottom + 120
                DispatchQueue.main.asyncAfter(deadline: .now()+0.15){
                    self.appealTextView.isHidden = false
                }
                self.detail.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.detail.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                self.backView.center.y = self.cardImageView.top + self.backView.height
                self.eventName.center.y = self.cardImageView.top + 10 + self.backView.height/2 + self.eventName.height/2
                self.cosmos.center.y = self.eventName.bottom + 10
                self.appealTextView.isHidden = true
                self.detail.center.y = self.backView.top + 10 + self.eventName.height/2
                self.eventName.isHidden = false
            }
        }
    }
    
    @objc private func hideDetail(){
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCardGesture))
        self.addGestureRecognizer(panGesture)
        cardImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backView.frame = CGRect(x: 0, y: cardImageView.frame.height/2, width: frame.width, height: frame.height)
        eventName.frame = CGRect(x: (frame.width/2)-((eventName.intrinsicContentSize.width+20)/2), y: backView.top+10, width:eventName.intrinsicContentSize.width+20, height: eventName.intrinsicContentSize.height+10)
        detail.frame = CGRect(x: 20, y: backView.top + eventName.height/2, width: endDetail.intrinsicContentSize.width, height: endDetail.intrinsicContentSize.height)
        cosmos.frame = CGRect(x: (frame.width/2)-((cosmos.intrinsicContentSize.width)/2), y: eventName.bottom+10, width: cosmos.intrinsicContentSize.width, height: cosmos.intrinsicContentSize.height)
        appealTextView.frame = CGRect(x: (frame.width/2)-((backView.frame.width-100)/2), y: cosmos.bottom+20, width: backView.frame.width-100, height: cardImageView.frame.height/3)
        ownerImage.frame = CGRect(x: cardImageView.left+10, y: cardImageView.bottom-40, width: 30, height: 30)
        ownerName.frame = CGRect(x: ownerImage.right+10, y: ownerImage.frame.minY, width: ownerName.intrinsicContentSize.width+10, height: ownerName.intrinsicContentSize.height+10)
        tagLabel.frame = CGRect(x: backView.left+10, y:cosmos.bottom+15 , width: tagLabel.intrinsicContentSize.width+10, height: tagLabel.intrinsicContentSize.height)
        placeLabel.frame = CGRect(x: tagLabel.left + 10, y: tagLabel.bottom+15, width: placeLabel.intrinsicContentSize.width, height: placeLabel.intrinsicContentSize.height)
        dateLabel.frame = CGRect(x: tagLabel.left+10, y: placeLabel.bottom+10, width: dateLabel.intrinsicContentSize.width, height: dateLabel.intrinsicContentSize.height)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: tagLabel.frame.width, height: tagLabel.frame.height)
        gradientLayer.colors = [UIColor.rgb(r: 224, g: 85, b: 108).cgColor,
                                UIColor.rgb(r: 146, g: 59, b: 228).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5)
        tagLabel.layer.insertSublayer(gradientLayer, at:0)
        goodLabel.frame = CGRect(x: 30, y: 400, width: 300, height: 50)
        nopeLabel.frame = CGRect(x: 30, y: 400, width: 300, height: 50)
    }
    
    
    @objc private func panCardGesture(gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: self)
        guard let view = gesture.view else { return }
        if gesture.state == .changed {
            self.handlePanChange(translation: translation)
        }else if gesture.state == .ended{
            self.handlePanEnded(view: view,translation: translation)
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
    private func handlePanEnded(view: UIView, translation: CGPoint) {
        
        if translation.x <= -120 {
            UIView.animate(withDuration: 1, delay: 0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7 ,options:[]) {
                let degree:CGFloat = -600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: -600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                self.removeFromSuperview()
            }
        }else if translation.x >= 120{
            UIView.animate(withDuration: 1, delay: 0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7 ,options:[]) {
                let degree:CGFloat = 600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: 600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                self.removeFromSuperview()
            }
        }else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                self.transform = .identity
                self.layoutIfNeeded()
                self.goodLabel.alpha = 0
                self.nopeLabel.alpha = 0
            }
        }
       }
    
    private func configure(with model:cardData){
        ownerName.text = model.ownerName
        eventName.text = model.eventTitle
        cardImageView.image = UIImage().getImageByUrl(url: model.eventImageURL!)
        for tagName in model.tagName {
            
            tagLabel.frame = CGRect(x: eventName.left, y: eventName.bottom+10, width: tagLabel.intrinsicContentSize.width, height: tagLabel.intrinsicContentSize.height)
            tagLabel.setTitle(tagName, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


