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
    
    private let bottomStack:UIStackView = {
       let stackView = UIStackView()
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let navView:UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        let button = UIButton()
        button.setTitle("おすすめ", for: .normal)
        let button2 = UIButton()
        button2.setTitle("相手から", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button2.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(CameraViewController.self, action:  #selector(recommend), for: .touchUpInside)
        button2.addTarget(CameraViewController.self, action: #selector(fromPartner), for: .touchUpInside)
        view.addSubview(button)
        view.addSubview(button2)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height)
        button2.frame = CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: view.frame.height)
        return view
    }()
    
    @objc private func recommend(){
        print("aaa")
    }
    
    @objc private func fromPartner(){
        
    }
    
    private let searchButton: UIButton = {
       let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.setImage(UIImage.resize(image: UIImage(systemName: "slider.horizontal.3")!.withTintColor(UIColor.white), width: 40), for: .normal)
        return button
    }()
    
    private let likeButton:UIButton = {
       let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = .white
        return button
    }()

    private let badButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage.resize(image: UIImage(systemName: "hand.wave")!, width: 40), for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = .white
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = navView
        navigationItem.titleView?.tintColor = .white
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        mainView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        view.addSubview(addButton)
        view.addSubview(mainView)
        view.addSubview(searchButton)
        view.addSubview(badButton)
        view.addSubview(likeButton)
        view.addSubview(bottomStack)
        bottomStack.addArrangedSubview(searchButton)
        bottomStack.addArrangedSubview(badButton)
        bottomStack.addArrangedSubview(likeButton)
        bottomStack.addArrangedSubview(addButton)
        bottomStack.distribution = .fillEqually
        searchButton.addTarget(self, action: #selector(goSearch), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cards = []
        let cardRef = Firestore.firestore().collection("Cards")
        cardRef.limit(to: 2).getDocuments{(querySnapshot, error) in
            if let error = error {
                print("addEventLisner失敗\(error)")
                return
            }
            if self.cards.count != 0 {
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
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.cards = []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.cards = []
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = CGRect(x: 10, y: view.safeAreaInsets.bottom+20, width: view.frame.width - 20, height:550)
        addButton.frame = CGRect(x: view.frame.width-50, y: 0, width: 50, height: 50)
      
        bottomStack.frame = CGRect(x: 0, y: mainView.bottom+20, width: view.frame.width, height: 80)
        likeButton.layer.cornerRadius = likeButton.frame.height/2
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
    
    @objc private func goSearch(){
        let modalViewController = CardsConditionsViewController()
        navigationController?.pushViewController(modalViewController, animated: true)
    }
}
