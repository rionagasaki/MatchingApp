//
//  ViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseAuth

struct Reccomend {
    let text:String
    let imageName:String
}

class ExploreViewController: UIViewController {
    
    private let reccomends = [Reccomend]()
    
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
        view.backgroundColor = .white
//        view.addSubview(imageView)
//        view.addSubview(makeCardButton)
//        view.addSubview(mainImage)
        navigationItem.title = "レコメンド"
        view.addSubview(reccomendTableView)
        reccomendTableView.backgroundColor = .orange
        makeCardButton.addTarget(self, action: #selector(newCard), for: .touchUpInside)
        reccomendTableView.register(HomeReccomendTableViewCell.self, forCellReuseIdentifier: HomeReccomendTableViewCell.identifier)
        reccomendTableView.delegate = self
        reccomendTableView.dataSource = self
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reccomendTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.bottom, width: view.frame.size.width, height: view.frame.height)
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
    
    private func configure(){
        
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
    
    private let reccomendTableView:UITableView = {
        let tableView = UITableView()
        return tableView
    }()
}
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reccomends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeReccomendTableViewCell.identifier, for: indexPath) as! HomeReccomendTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}

