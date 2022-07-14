//
//  PasswordChangeViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/13.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        view.addSubview(mainTitle)
        view.addSubview(passwordField)
        view.addSubview(newPasswordField)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainTitle.frame = CGRect(x: (view.frame.width/2)-((view.frame.size.width-60)/2), y: view.frame.height/5, width: mainTitle.intrinsicContentSize.width, height: mainTitle.intrinsicContentSize.height)
        passwordField.frame = CGRect(x: (view.frame.width/2)-((view.frame.size.width-60)/2), y: mainTitle.bottom+10, width: view.frame.size.width-60, height: 50)
        newPasswordField.frame = CGRect(x: (view.frame.width/2)-((view.frame.size.width-60)/2), y: passwordField.bottom+30, width:view.frame.size.width-60, height: 50)
        backButton.frame = CGRect(x: view.frame.width/20, y: view.safeAreaInsets.top+20, width: backButton.intrinsicContentSize.width, height: backButton.intrinsicContentSize.height)
    }
    
    private let mainTitle:UILabel = {
       let label = UILabel()
        label.text = "現在のパスワードと、新しいパスワードを入力してください。"
        return label
    }()
    
    private let passwordField:UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .black
        textfield.placeholder = "現在のパスワード"
        textfield.tintColor = .white
        textfield.textColor = .white
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(string: "現在のパスワード",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        return textfield
    }()
    
    private let newPasswordField:UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .black
        textfield.placeholder = "新しいパスワード"
        textfield.tintColor = .white
        textfield.textColor = .white
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(string: "新しいパスワード",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        return textfield
    }()
    
    private let changeButton:UIButton = {
       let button = UIButton()
        button.setTitle("パスワードを変更", for: .normal)
        return button
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("設定一覧", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.configuration?.imagePadding = CGFloat(20)
        button.tintColor = .white
        return button
    }()
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
}


