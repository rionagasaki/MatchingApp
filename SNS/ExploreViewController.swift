//
//  ViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseAuth

class ExploreViewController: UIViewController {

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let auth = Auth.auth()
        auth.addStateDidChangeListener{(auth, user) in
        if (user != nil) {
            print("userです",user!)
        }else{
            print("no user")
            let modalViewController = LoginViewController()
            modalViewController.modalPresentationStyle = .fullScreen
            self.present(modalViewController, animated: true, completion: nil)
        }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        view.addSubview(imageView)
        view.addSubview(makeCardButton)
        view.addSubview(mainImage)
        makeCardButton.addTarget(self, action: #selector(newCard), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        mainImage.frame = CGRect(x: 30, y: view.frame.height/10, width: view.frame.width-50, height: view.frame.height-view.frame.height/2)
        imageView.frame = CGRect(x:(view.frame.width/2)-150, y: mainImage.bottom+10, width: 300, height: 50)
        makeCardButton.frame = CGRect(x: (view.frame.width/2)-150, y: imageView.bottom+20, width: 300, height: 60)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: makeCardButton.frame.width, height: makeCardButton.frame.height)
        gradientLayer.colors = [UIColor.rgb(r: 224, g: 85, b: 108).cgColor,
                                UIColor.rgb(r: 146, g: 59, b: 228).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5)
        makeCardButton.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cardText")
        return imageView
    }()
    
    private let makeCardButton: UIButton = {
       let button = UIButton()
        button.setTitle("カードを追加", for: .normal)
        button.titleLabel!.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        return button
    }()
    
    private let mainImage:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named:"ImageCard")
        return imageView
    }()
    
    @objc private func newCard(){
        let modalViewController = PublishPostViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        
        self.present(modalViewController, animated: true, completion: nil)
    }
}
