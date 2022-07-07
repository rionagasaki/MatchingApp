//
//  EmailChangeViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/03.
//

import UIKit

class EmailChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        saveButton.isHidden = true
        saveButton.isEnabled = false
        view.addSubview(emailField)
        view.addSubview(label)
        view.addSubview(saveButton)
        view.addSubview(backButton)
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveEmail), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        DatabaseManager.shared.getDocument{ doc in
            self.emailField.text = doc.email
            self.viewDidLayoutSubviews()
        }
    }
    
    @objc func textFieldDidChange(){
        saveButton.isEnabled = true
        saveButton.isHidden = false
    }
    
    @objc func saveEmail(){
        if emailField.text == "" {
            return
        }
        DatabaseManager.shared.updateDocument(key: "email", text: self.emailField.text!)
        dismiss(animated: true)
    }
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
    private let emailField:UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .black
        textfield.placeholder = "メールアドレス"
        textfield.tintColor = .white
        textfield.textColor = .white
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(string: "メールアドレス",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        return textfield
    }()
    
    private let saveButton:UIButton = {
       let button = UIButton()
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
        
    private let label:UILabel = {
       let label = UILabel()
        label.textColor = .systemGray2
        label.text = "メールアドレス"
        return label
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("設定一覧", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.configuration?.imagePadding = CGFloat(20)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: (view.frame.width/2)-((view.frame.size.width-60)/2), y: view.frame.height/5, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        emailField.frame = CGRect(x: (view.frame.width/2)-((view.frame.size.width-60)/2), y: label.bottom+10, width: view.frame.size.width-60, height: 50)
        saveButton.frame = CGRect(x: view.frame.width/1.2, y: backButton.top-7, width: saveButton.intrinsicContentSize.width, height: saveButton.intrinsicContentSize.height)
        backButton.frame = CGRect(x: view.frame.width/20, y: view.safeAreaInsets.top+20, width: backButton.intrinsicContentSize.width, height: backButton.intrinsicContentSize.height)
    }
    
    
}
