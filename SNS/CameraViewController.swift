//
//  CameraViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import KRProgressHUD

class CameraViewController: UIViewController {
    
    private var cards = [cardData]()
    
    private let mainView:UIView = {
        let view = UIView()
        return view
    }()
    
    private let addButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let myPage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bubbleCard")
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = myPage
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        mainView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        view.addSubview(addButton)
       
        view.addSubview(mainView)
        cards = []
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        let cardRef = Firestore.firestore().collection("Cards")
        cardRef.getDocuments{(querySnapshot, error) in
            if let error = error {
                print("addEventLisner失敗\(error)")
                return
            }
            self.cards = []
            if querySnapshot?.isEmpty == true { return }
            for document in querySnapshot!.documents {
                let cardDate = cardData(document: document)
                self.cards.append(cardDate)
                print("count",self.cards.count)
                    let cardView = CardView(model: cardDate)
                    self.mainView.addSubview(cardView)
                    cardView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: self.mainView.frame.height)
            }
            print("end")
            KRProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cards = []
        self.mainView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = CGRect(x: 10, y: (view.frame.height/2)-(550/2), width: view.frame.width - 20, height:550)
        addButton.frame = CGRect(x: view.frame.width-100, y: view.frame.height-200, width: 70, height: 70)
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = addButton.height/2
        view.bringSubviewToFront(addButton)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: addButton.frame.width, height: addButton.frame.height)
        gradientLayer.colors = [UIColor.rgb(r: 224, g: 85, b: 108).cgColor,
                                UIColor.rgb(r: 146, g: 59, b: 228).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5)
        addButton.layer.insertSublayer(gradientLayer, at:0)
    }
}
