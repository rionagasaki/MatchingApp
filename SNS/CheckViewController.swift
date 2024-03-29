//
//  CheckViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/21.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore

class CheckViewController: UIViewController {

    public var eventPlace:String?
    public var eventImage: UIImage!
    public var eventTitle: String!
    public var tagTitle:[String]?
    public var appeal:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(checkCard)
        view.addSubview(nextButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        checkCard.frame = CGRect(x: (view.frame.width/2)-((view.frame.width-20)/2), y: mainLabel.bottom+30, width: view.frame.width-20, height: 550)
        nextButton.frame = CGRect(x: (view.frame.width/2)-150, y: checkCard.bottom+30, width: 300, height: 55)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: nextButton.frame.width, height: nextButton.frame.height)
        gradientLayer.colors = [UIColor.rgb(r: 224, g: 85, b: 108).cgColor,
                                UIColor.rgb(r: 146, g: 59, b: 228).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5)
        nextButton.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    private let mainLabel:UILabel = {
        let label = UILabel()
        label.text = "以下のカードが作成されます。"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let checkCard:CardView = {
       let card = CardView()
        return card
    }()
    
    private let nextButton:ButtonAnimated = {
        let button = ButtonAnimated.nextButton()
        button.setTitle("発行する", for: .normal)
        return button
    }()
    
    private let backButton:UIButton = {
        UIButton.backButton()
    }()
    
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    @objc func nextScreen(){
        KRProgressHUD.showSuccess()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        Firestore.firestore().collection("Cards").document().setData([
            "ownername":"",
            "":""
        ])
        
    }
}
