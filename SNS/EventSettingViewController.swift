//
//  PostEditterViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit

class EventSettingViewController: UIViewController {
    
    public var eventImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(titleTextField)
        view.addSubview(mainLabel)
        view.addSubview(nextButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        titleTextField.frame = CGRect(x: 40, y: mainLabel.bottom+60, width: 300, height: 50)
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        nextButton.frame = CGRect(x: 30, y: titleTextField.bottom+30, width: 300, height: 55)
    }
    
   
    private let titleTextField:CustomTextField = {
        let textfield = CustomTextField()
        textfield.placeholder = "イベント名"
        return textfield
    }()
    
    private let mainLabel:UILabel = {
       let label = UILabel()
        label.text = "作りたいイベント名を入力してください"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let nextButton:ButtonAnimated = {
        let button = ButtonAnimated.nextButton()
        button.isEnabled = false
        button.backgroundColor = .systemGray3
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
    @objc func nextScreen(){
        let modalViewController = EventDetailViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        modalViewController.eventImage = eventImage
        modalViewController.eventTitle = titleTextField.text
        let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
        self.present(modalViewController, animated: false, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        if titleTextField.text != "" {
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
            nextButton.isEnabled = true
        }else{
            nextButton.backgroundColor = .systemGray3
            nextButton.setTitleColor(UIColor.black, for: .normal)
            nextButton.isEnabled = false
        }
    }
}
