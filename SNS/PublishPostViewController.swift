//
//  PublishPostViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import FirebaseAuth

class PublishPostViewController: UIViewController {

    private var setImage = false
    private var imageData:UIImage?
    private var ownerName:String = ""
    private let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(addImageButton)
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(nextButton)
        checked()
        addImageButton.addSubview(cardImageView)
        addImageButton.isUserInteractionEnabled = true
        addImageButton.addTarget(self, action: #selector(photoAccess), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("user").document(uid!).getDocument{ document, error in
            if let error = error {
                print("getDocuentError\(error)")
                return
            }
            let userData = userData(document: document!)
            self.ownerName = userData.username!
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x: (view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        addImageButton.frame = CGRect(x: 30, y: mainLabel.bottom+40, width: view.frame.width-60, height: view.frame.width-60)
        cardImageView.frame = CGRect(x:0, y:0, width:addImageButton.frame.width, height: addImageButton.frame.height)
        nextButton.frame = CGRect(x: (view.width/2)-150, y: addImageButton.bottom+30, width: 300, height: 55)
    }
    
    private func checked(){
        if setImage{
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private let mainLabel:UILabel = {
       let label = UILabel()
        label.text = "イメージ画像を追加してください"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let cardImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 30
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private let addImageButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = .clear
        return button
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let nextButton:ButtonAnimated = {
       let button = ButtonAnimated()
        button.backgroundColor = .systemGray3
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 25
        button.setTitle("次へ", for: .normal)
        button.isEnabled = false
        return button
    }()

}
extension PublishPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func photoAccess(){
        KRProgressHUD.set(duration: 1.0)
        KRProgressHUD.show()
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
    
    @objc func back(){
        self.dismiss(animated: true)
    }
    
    @objc func nextScreen(){
        let modalViewController = EventSettingViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        let cardInfo = CardInfo(ownwename: ownerName,ownerUid: uid!, eventImage: imageData!, place: "", eventTitle: "", deadLine: false, eventDate:[""], tagName:[""] , appeal: "")
        modalViewController.cardInfo = cardInfo
        let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
        self.present(modalViewController, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            cardImageView.contentMode = .scaleToFill
            cardImageView.image = editImage.withRenderingMode(.alwaysOriginal)
            imageData = editImage.withRenderingMode(.alwaysOriginal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            cardImageView.contentMode = .scaleToFill
            cardImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            imageData = originalImage.withRenderingMode(.alwaysOriginal)
        }
        self.nextButton.isEnabled = true
        self.setImage = true
        self.checked()
        dismiss(animated: true, completion: nil)
    }
}


