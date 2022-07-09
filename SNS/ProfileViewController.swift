//
//  ProfileViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import KRProgressHUD
import SkeletonView

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath)
        cell.frame.size.width = 100
        cell.frame.size.height = 100
        return cell
    }

    @IBOutlet weak var PostCollectionView: UICollectionView!

    
    private let myPage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "My Page")
        return imageView
    }()
    
    
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.darkGray))
        image.tintColor = .darkGray
        image.backgroundColor = .systemGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 70
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.systemGray4.cgColor
        return image
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 21)
        return label
    }()
    
    private let camera: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.borderWidth = 1
        button.setImage(UIImage.resize(image: UIImage(named: "camera")!, width: 30), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let topstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let setting: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .systemOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
       return button
    }()
    
    private let bottomstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        return stackView
    }()
    
    private let friendItem: UIButton = {
       let button = UIButton()
        button.setImage(UIImage.resize(image: UIImage(named: "friend")!, width: 25), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let friendLabel: UILabel = {
        let label = UILabel()
        label.text = "13"
        
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        return label
    }()
    
    private let kingLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        return label
    }()
    
    private let kingItem: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.resize(image: UIImage(named: "king")!, width: 25), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let addressItem: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "pin")!
        image.withTintColor(.systemRed)
        button.setImage(UIImage.resize(image: image, width: 25), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.text = "Japan, Chiba"
       label.textColor = .systemGray2
        label.font = UIFont(name: "MarkerFelt-Thin", size: 15)
       return label
    }()
   
    @objc private func goSetting(){
        let modalViewController = AccountSettingViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func signOutButtonTaped(){
        AuthManager.shared.logoutUser{ result in
            if result == true{
                let modalViewController = LoginViewController()
                modalViewController.modalPresentationStyle = .fullScreen
                self.present(modalViewController, animated: true, completion: nil)
            }else{
                print("logOut Error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.getDocument{ doc in
            self.nameLabel.text = doc.username
            self.image.image = UIImage().getImageByUrl(url: doc.profileImage ?? "")
            self.viewWillLayoutSubviews()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostCollectionView.delegate = self
        PostCollectionView.dataSource = self
        PostCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        view.addSubview(setting)
        view.addSubview(image)
        view.addSubview(camera)
        view.addSubview(nameLabel)
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        topstackView.addArrangedSubview(addressItem)
        topstackView.addArrangedSubview(addressLabel)
        bottomstackView.addArrangedSubview(friendItem)
        bottomstackView.addArrangedSubview(friendLabel)
        bottomstackView.addArrangedSubview(kingItem)
        bottomstackView.addArrangedSubview(kingLabel)
        allStackView.addSubview(bottomstackView)
        allStackView.addSubview(topstackView)
        view.addSubview(myPage)
        view.addSubview(allStackView)
        setting.addTarget(self, action: #selector(goSetting), for: .touchUpInside)
        camera.addTarget(self, action: #selector(photoAccess), for: .touchUpInside)
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        DatabaseManager.shared.getDocument{ doc in
            self.nameLabel.text = doc.username
            self.image.image = UIImage().getImageByUrl(url: doc.profileImage ?? "")
            self.viewWillLayoutSubviews()
            KRProgressHUD.dismiss()
        }
    }
    
    override func viewWillLayoutSubviews() {
        image.frame = CGRect(x: 30, y: view.safeAreaInsets.top+50, width: 140, height: 140)
        camera.frame = CGRect(x: 35, y: image.bottom-50, width: 40, height: 40)
        nameLabel.frame = CGRect(x: view.width-195, y: view.safeAreaInsets.top+70, width: nameLabel.intrinsicContentSize.width, height:nameLabel.intrinsicContentSize.height)
        allStackView.frame = CGRect(x: view.width-200, y: nameLabel.bottom+5, width: 150, height: 70)
        topstackView.frame = CGRect(x: 0, y: 0, width: allStackView.width, height: allStackView.height/2)
        bottomstackView.frame = CGRect(x: 0, y: topstackView.bottom, width: allStackView.width, height: allStackView.height/2)
        myPage.frame = CGRect(x:view.frame.width/2-view.frame.width/10, y: view.frame.height/20, width: view.frame.width/4, height: 60)
        setting.frame = CGRect(x:view.frame.width-90 + view.frame.width/20, y: view.safeAreaInsets.top+70, width: 30, height: 30)
    }
}

class PostView: UICollectionView ,UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCell.identifier, for: indexPath)
        collectionView.backgroundColor = .black
        return cell
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func photoAccess(){
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            }
            KRProgressHUD.dismiss()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            self.image.contentMode = .scaleToFill
            self.image.image = editImage.withRenderingMode(.alwaysOriginal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            self.image.contentMode = .scaleToFill
            self.image.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        guard let profileImage = self.image.image else { return }
        guard let uploadImage = profileImage.jpegData(compressionQuality: 0.3) else { return }
        print(uploadImage)
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        storageRef.putData(uploadImage, metadata: nil){(metadata, err) in
            if let err = err {
                print("Firestorageへの保存失敗\(err)")
                return
            }
            storageRef.downloadURL{(url, err) in
                if let err = err {
                    print("FireStorageからのダウンロードに失敗\(err)")
                    return
                }
                guard let urlString = url?.absoluteString else { return }
                print(urlString)
                let currentUser = Auth.auth().currentUser!.uid
                Firestore.firestore().collection("user").document(currentUser).updateData([
                    "profileImage":urlString,
                ]){ err in
                    if let err = err{
                        print("Firestoreへの保存が失敗\(err)")
                        return
                    }
                    print("all Success")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
