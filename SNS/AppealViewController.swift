//
//  AppealViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/21.
//

import UIKit

class AppealViewController: UIViewController {

    public var eventPlace:String?
    public var eventImage: UIImage!
    public var eventTitle: String!
    public var tagTitle:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(nextButton)
        view.addSubview(textView)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        textView.frame = CGRect(x: (view.frame.width - 300)/2, y: mainLabel.bottom+40, width: 300, height: 200)
        nextButton.frame = CGRect(x: (view.frame.width - 300)/2, y: textView.bottom+40, width: 300, height: 55)
    }
    
    private let mainLabel:UILabel = {
        let label = UILabel()
        label.text = "アピールを書いてください(20文字以上)"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    private let nextButton:ButtonAnimated = {
        ButtonAnimated.nextButton()
    }()
    
    private let backButton:UIButton = {
        UIButton.backButton()
    }()
    
    private let textView:UITextView = {
       let textView = UITextView()
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 30
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        return textView
    }()
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
    @objc func nextScreen(){
        let modalViewController = CheckViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        modalViewController.eventImage = eventImage
        modalViewController.eventTitle = eventTitle
        modalViewController.eventPlace = eventPlace
        modalViewController.tagTitle = tagTitle
        modalViewController.appeal = textView.text
        let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
        self.present(modalViewController, animated: false, completion: nil)
    }

}
