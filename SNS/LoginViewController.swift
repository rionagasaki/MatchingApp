//
//  LoginViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//
import SafariServices
import UIKit


class LoginViewController: UIViewController {
    
    public struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    static let shared = LoginViewController()
    
    private let usernameEmailField: UITextField = {
       let field = UITextField()
        field.placeholder = "Username or Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.isSecureTextEntry = false
       return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        return button
    }()
    
    
    private let createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 20)
        return  button
    }()
    
    
    private let termsButton: UIButton = {
       let button = UIButton()
        button.setTitle("Terms of Servicd", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
       return button
    }()
    
    
    private let privacyButton: UIButton = {
        let button = UIButton()
         button.setTitle("Privacy Policy", for: .normal)
         button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    
    private let headerView: UIView = {
       let header = UIView()
        header.clipsToBounds = true
        let backgroundImage = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImage)
        return header
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        usernameEmailField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        addSubviews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height:view.height/3.0)
        
        let imageView = UIImageView(image: UIImage(named: "text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0, y: view.safeAreaInsets.top, width: headerView.width/2.0, height: headerView.height - view.safeAreaInsets.top)
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 10,
            width: view.width - 50,
            height: 52.0)
        
        passwordField.frame = CGRect(x: 25, y: usernameEmailField.bottom + 10, width: view.width - 50, height: 52.0)
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width - 50, height: 52.0)
        
        createAccountButton.frame = CGRect(x: 25, y: loginButton.bottom + 10, width: view.width-50, height: 52.0)
        
        termsButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width - 20, height: 50)
        
        privacyButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 90, width: view.width - 20, height: 50)
       
        configureHeaderView()
    }
    
    private func configureHeaderView(){
        
        guard headerView.subviews.count == 1 else{
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
    }
    
    private func addSubviews(){
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
    }
    
    @objc private func didTapLoginButton(){
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
                  return
              }
        var email: String?
        var name: String?
    
        if usernameEmail.contains("@"), usernameEmail.contains("."){
           email = usernameEmail
        }else {
           name = usernameEmail
        }
        print("password",password)
        AuthManager.shared.loginUser(username: name, email: email, passowrd: password){ [unowned self] result in
            DispatchQueue.main.async {
                if result{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Log In Error", message: "We were unable to log you in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func didTapTermsButton(){
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton(){
        guard let url = URL(string: "https://help.instagram.com/196883487377501") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    @objc private func didTapCreateButton(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            didTapLoginButton()
        }
        return true
    }
}
