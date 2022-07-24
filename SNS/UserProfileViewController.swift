//
//  UserProfileViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/17.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import KRProgressHUD
import SkeletonView

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var images = [UIImageView]()
    private var firstCollectionView:UICollectionView?
    private var secondCollectionView:UICollectionView?
    private var follow:Bool!
    var collections: [UICollectionView] = []
    var scrollBeginingPoint: CGPoint!
    var currentPoint:CGPoint!
    let firstFlowLayout = UICollectionViewFlowLayout()
    let secondFlowLayout = UICollectionViewFlowLayout()
    
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
        view.backgroundColor = .white
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
        button.setTitle("フォロー", for: .normal)
        button.setTitleColor(UIColor.systemOrange, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
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
        button.setImage(UIImage.resize(image: UIImage(systemName: "person.2")!.withTintColor(.white), width: 25), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let friendLabel: UILabel = {
        let label = UILabel()
        label.text = "13"
        label.textColor = .white
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
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "square.and.arrow.down")
        return imageView
    }()
    
    private let secondImage:UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
   
    @objc private func goSetting(){
        if follow {
            setting.backgroundColor = .white
            setting.setTitle("フォロー", for: .normal)
            setting.setTitleColor(UIColor.systemOrange, for: .normal)
            follow = false
        }else{
            setting.backgroundColor = .systemOrange
            setting.setTitle("フォロー中", for: .normal)
            setting.setTitleColor(UIColor.white, for: .normal)
            follow = true
        }
    }
    
    @objc private func goMessages(){
        let modalViewController = MessageViewController()
        self.navigationController?.pushViewController(modalViewController, animated: true)
    }
    
    @objc func signOutButtonTaped(){
        AuthManager.shared.logoutUser{ result in
            if result == true{
                let modalViewController = LoginViewController()
                modalViewController.modalPresentationStyle = .fullScreen
                self.present(modalViewController, animated: true, completion: nil)
            }else{
                print("logout Error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.getDocument{ doc in
            self.nameLabel.text = doc.username
            self.image.image = UIImage.getImageByUrl(url: doc.profileImage ?? "")
            self.viewWillLayoutSubviews()
        }
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        pageControl = UIPageControl(frame: .zero)
        firstFlowLayout.itemSize = CGSize(width: (view.frame.size.width/3)-2, height: (view.frame.size.width/3)-2)
        secondFlowLayout.itemSize = CGSize(width: (view.frame.size.width/3)-2, height: (view.frame.size.width/3)-2)
        firstFlowLayout.minimumLineSpacing = 2
        firstFlowLayout.minimumInteritemSpacing = 1
        firstFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 1, bottom: 10, right: 1)
        secondFlowLayout.minimumLineSpacing = 2
        secondFlowLayout.minimumInteritemSpacing = 1
        secondFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 1, bottom: 10, right: 1)
        firstCollectionView = UICollectionView(frame: .zero, collectionViewLayout: firstFlowLayout)
        secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: secondFlowLayout)
        scrollView = UIScrollView(frame: .zero)
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        view.addSubview(pageControl)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        follow = false
        guard let firstCollectionView = firstCollectionView else {
            return
        }
        guard let secondCollectionView = secondCollectionView else {
            return
        }
        view.addSubview(scrollView)
        scrollView.addSubview(firstCollectionView)
        scrollView.addSubview(secondCollectionView)
        firstCollectionView.register(MyCardsCollectionViewCell.self, forCellWithReuseIdentifier: MyCardsCollectionViewCell.identifier)
        secondCollectionView.register(MyContentsCollectionViewCell.self, forCellWithReuseIdentifier: MyContentsCollectionViewCell.identifier)
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        firstCollectionView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        secondCollectionView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        topstackView.addArrangedSubview(addressItem)
        topstackView.addArrangedSubview(addressLabel)
        bottomstackView.addArrangedSubview(friendItem)
        bottomstackView.addArrangedSubview(friendLabel)
        bottomstackView.addArrangedSubview(kingItem)
        bottomstackView.addArrangedSubview(kingLabel)
        allStackView.addSubview(bottomstackView)
        allStackView.addSubview(topstackView)
        view.addSubview(allStackView)
        view.addSubview(border)
        setting.addTarget(self, action: #selector(goSetting), for: .touchUpInside)
        messages.addTarget(self, action: #selector(goMessages), for: .touchUpInside)
        camera.addTarget(self, action: #selector(photoAccess), for: .touchUpInside)
        KRProgressHUD.show(withMessage: "", completion: nil)
        DatabaseManager.shared.getDocument{ doc in
            self.nameLabel.text = doc.username
            self.image.image = UIImage.getImageByUrl(url: doc.profileImage ?? "")
            self.viewWillLayoutSubviews()
            KRProgressHUD.dismiss()
        }
    }
    
    @objc private func firstButton(){
        firstImage.tintColor = .white
        secondImage.tintColor = .darkGray
        pageControl.currentPage = 1
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.border.frame = CGRect(x: 0, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
        }
    }
    
    @objc private func secondButton(){
        firstImage.tintColor = .darkGray
        secondImage.tintColor = .white
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
        setting.frame = CGRect(x:view.frame.width - 150, y:view.safeAreaInsets.bottom+20, width: setting.intrinsicContentSize.width+30, height: setting.intrinsicContentSize.height)
        messages.frame = CGRect(x:setting.right+20, y:view.safeAreaInsets.bottom+20, width: 30, height: 30)
        scrollView.frame = CGRect(x:0, y: image.bottom+45, width: view.frame.width, height: view.frame.height-image.bottom-10)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width*2, height: 200)
        firstCollectionView!.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        secondCollectionView!.frame = CGRect(x: view.width, y: 0, width: view.width, height: view.height)
        pageControl.frame = CGRect(x: 0, y: image.bottom+10, width: self.view.frame.size.width, height: 30)
        view.addSubview(firstImage)
        view.addSubview(secondImage)
        firstImage.isUserInteractionEnabled = true
        secondImage.isUserInteractionEnabled = true
        firstImage.frame = CGRect(x: 0, y: image.bottom+10, width: view.frame.width/2, height: 30)
        secondImage.frame = CGRect(x: firstImage.right, y: image.bottom+10, width: view.frame.width/2, height: 30)
        firstImage.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(firstButton)))
        secondImage.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(secondButton)))
        border.frame = CGRect(x: 0, y: firstImage.bottom+5, width: view.frame.width/2, height: 2)
        images = [firstImage, secondImage]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if images[pageControl.currentPage] == firstImage{
            secondImage.tintColor = .darkGray
        }else if images[pageControl.currentPage] == secondImage{
            firstImage.tintColor = .darkGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstCollectionView {
            return 30
        }else{
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCardsCollectionViewCell.identifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyContentsCollectionViewCell.identifier, for: indexPath)
            return cell
        }
    }
}
extension UserProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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

extension UserProfileViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            scrollBeginingPoint = scrollView.contentOffset
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPoint = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollBeginingPoint.x > currentPoint.x)
        if pageControl.currentPage == 0 {
            if scrollBeginingPoint.x > currentPoint.x{
                return
            }
            images[0].tintColor = .white
            images[1].tintColor = .darkGray
            UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
                self.border.frame = CGRect(x: 0, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
            }
        }else if pageControl.currentPage != 0 && scrollBeginingPoint.x > currentPoint.x {
            if scrollBeginingPoint.x > currentPoint.x {
                return
            }
            images[0].tintColor = .darkGray
            images[1].tintColor = .white
            UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
                self.border.frame = CGRect(x: self.view.frame.width/2, y: self.firstImage.bottom+5, width: self.view.frame.width/2, height: 2)
            }
        }
    }
}
