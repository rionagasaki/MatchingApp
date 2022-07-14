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

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var images = [UIImageView]()
    var collections: [UICollectionView] = []
    let flowLayout = UICollectionViewFlowLayout()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath)
        cell.frame.size.width = 100
        cell.frame.size.height = 100
        return cell
    }

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
    
    private let border:UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
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
    
    private let messages: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
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
    
    private let firstImage:UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "square.and.arrow.down")
        return imageView
    }()
    
    private let secondImage:UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
   
    @objc private func goSetting(){
        let modalViewController = AccountSettingViewController()
        self.navigationController?.pushViewController(modalViewController, animated: true)
    }
    
    @objc private func goMessages(){
        let modalViewController = ChatViewController()
        self.navigationController?.pushViewController(modalViewController, animated: true)
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
        
        view.addSubview(setting)
        view.addSubview(messages)
        navigationItem.titleView = myPage
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
        view.addSubview(allStackView)
        setting.addTarget(self, action: #selector(goSetting), for: .touchUpInside)
        messages.addTarget(self, action: #selector(goMessages), for: .touchUpInside)
        camera.addTarget(self, action: #selector(photoAccess), for: .touchUpInside)
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        DatabaseManager.shared.getDocument{ doc in
            self.nameLabel.text = doc.username
            self.image.image = UIImage().getImageByUrl(url: doc.profileImage ?? "")
            self.viewWillLayoutSubviews()
            KRProgressHUD.dismiss()
        }
    }
    
    @objc private func firstButton(){
        firstImage.tintColor = .orange
        secondImage.tintColor = .systemGray5
        pageControl.currentPage = 1
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.border.frame = CGRect(x: 0, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
        }
    }
    
    @objc private func secondButton(){
        firstImage.tintColor = .systemGray5
        secondImage.tintColor = .orange
        pageControl.currentPage = 0
        scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
            self.border.frame = CGRect(x: self.view.frame.width/2, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
        }
    }
    
    override func viewWillLayoutSubviews() {
        image.frame = CGRect(x: 30, y: view.safeAreaInsets.top+50, width: 140, height: 140)
        camera.frame = CGRect(x: 35, y: image.bottom-50, width: 40, height: 40)
        nameLabel.frame = CGRect(x: view.width-195, y: view.safeAreaInsets.top+70, width: nameLabel.intrinsicContentSize.width, height:nameLabel.intrinsicContentSize.height)
        allStackView.frame = CGRect(x: view.width-200, y: nameLabel.bottom+5, width: 150, height: 70)
        topstackView.frame = CGRect(x: 0, y: 0, width: allStackView.width, height: allStackView.height/2)
        bottomstackView.frame = CGRect(x: 0, y: topstackView.bottom, width: allStackView.width, height: allStackView.height/2)
        setting.frame = CGRect(x:view.frame.width - 100, y:view.safeAreaInsets.bottom+20, width: 30, height: 30)
        messages.frame = CGRect(x:setting.right+20, y:view.safeAreaInsets.bottom+20, width: 30, height: 30)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        scrollView = UIScrollView(frame: CGRect(x:0, y: image.bottom+45, width: view.frame.width, height: view.frame.height-image.bottom-10))
        scrollView.contentSize = CGSize(width: self.view.frame.size.width*2, height: 200)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .orange
        view.addSubview(scrollView)
        let firstCollectionView = UICollectionView(frame: CGRect(x:0, y: view.top, width: view.frame.width, height: view.height), collectionViewLayout: flowLayout)
        let secondCollectionView = UICollectionView(frame: CGRect(x:view.frame.width, y: view.top, width: view.frame.width, height: view.height), collectionViewLayout: flowLayout)
        scrollView.addSubview(firstCollectionView)
        scrollView.addSubview(secondCollectionView)
        firstCollectionView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        secondCollectionView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        firstCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        secondCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collections = [firstCollectionView, secondCollectionView]
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        pageControl = UIPageControl(frame: CGRect(x: 0, y: image.bottom+10, width: self.view.frame.size.width, height: 30))
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        view.addSubview(pageControl)
        view.addSubview(firstImage)
        view.addSubview(secondImage)
        firstImage.frame = CGRect(x: 0, y: image.bottom+10, width: view.frame.width/2, height: 30)
        secondImage.frame = CGRect(x: firstImage.right, y: image.bottom+10, width: view.frame.width/2, height: 30)
        images = [firstImage, secondImage]
        images[pageControl.currentPage].tintColor = .orange
        firstImage.isUserInteractionEnabled = true
        secondImage.isUserInteractionEnabled = true
        firstImage.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(firstButton)))
        secondImage.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(secondButton)))
        view.addSubview(border)
        border.frame = CGRect(x: 0, y: firstImage.bottom+5, width: view.frame.width/2, height: 2)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if images[pageControl.currentPage] == firstImage{
            secondImage.tintColor = .systemGray5
        }else if images[pageControl.currentPage] == secondImage{
            firstImage.tintColor = .systemGray5
        }
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

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if pageControl.currentPage == 0 {
            print("aa")
            images[0].tintColor = .orange
            images[1].tintColor = .systemGray5
            UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
                self.border.frame = CGRect(x: 0, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
            }
        }else{
            images[0].tintColor = .systemGray5
            images[1].tintColor = .orange
            UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
                self.border.frame = CGRect(x: self.view.frame.width/2, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
            }
        }
    }
}


