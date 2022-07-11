//
//  RegisterViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit

class RegisterViewController: UIViewController {
    
    struct corner{
        static func cornerRedius()->CGFloat{
            return 8.0
        }
        static func borderRedius()-> CGFloat{
            return 1.0
        }
    }
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "username..."
        field.returnKeyType = .next
        field.layer.cornerRadius = corner.cornerRedius()
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.backgroundColor = .secondarySystemBackground
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.autocapitalizationType = .none
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.cornerRadius = corner.cornerRedius()
        field.layer.masksToBounds = true
        field.layer.borderWidth = corner.borderRedius()
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "password..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.autocapitalizationType = .none
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.cornerRadius = corner.cornerRedius()
        field.layer.masksToBounds = true
        field.layer.borderWidth = corner.borderRedius()
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.isSecureTextEntry = true
        return field
    }()
    
    private let createButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = corner.cornerRedius()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(createButton)
        
        createButton.addTarget(self, action: #selector(didTapResister), for: .touchUpInside)
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        usernameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+10, width: view.width-40, height: 52)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom + 10, width: view.width-40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 52)
        createButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 52)
    }
    
    @objc private func didTapResister(){
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        AuthManager.shared.registerNewUser(username: usernameField.text!, email: emailField.text!, password: passwordField.text!){
            success in
            if success {
                self.dismiss(animated: true, completion: nil)
                
            }else{
                print("error")
            }
        }
    }
    
}
extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            usernameField.becomeFirstResponder()
        }else if textField == emailField{
            emailField.becomeFirstResponder()
        }else{
            didTapResister()
        }
        return true
    }
}
