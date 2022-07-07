//
//  EventDetailViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/20.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    
    public var eventPlace:String?
    public var eventImage: UIImage!
    public var eventTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(mapButton)
        view.addSubview(placeTextField)
        view.addSubview(numberTextField)
        view.addSubview(nextButton)
        mapButton.addTarget(self, action: #selector(mapPage), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        placeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if eventPlace != "" && eventPlace != nil{
            placeTextField.text = eventPlace
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
            nextButton.isEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        placeTextField.frame = CGRect(x:(view.frame.width/2)-150, y: mainLabel.bottom+60, width: 300, height: 55)
        mapButton.frame = CGRect(x: (view.frame.width/2)-150, y: placeTextField.bottom+20, width: 300, height: 55)
        nextButton.frame = CGRect(x: (view.frame.width/2)-150, y: mapButton.bottom+30, width: 300, height: 55)
    }
    
    private let mainLabel:UILabel = {
        let label = UILabel()
        label.text = "イベントの開催場所を追加してください"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let numberTextField:CustomTextField = {
        let textfield = CustomTextField()
        textfield.placeholder = "人数"
        return textfield
    }()
    
    private let mapButton:UIButton = {
       let button = UIButton()
        button.setTitle("マップから選択", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    
    private let nextButton:ButtonAnimated = {
        let button = ButtonAnimated.nextButton()
        button.isEnabled = false
        button.backgroundColor = .systemGray3
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let backButton:UIButton = {
        UIButton.backButton()
    }()
    
    private let placeTextField:CustomTextField = {
       let textfield = CustomTextField()
        textfield.placeholder = "集合場所"
        return textfield
    }()
    
    @objc private func mapPage(){
        let mapViewController = MapViewController()
        mapViewController.modalPresentationStyle = .fullScreen
        self.present(mapViewController, animated: false, completion: nil)
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
        let modalViewController = PeopleNumberViewController()
        modalViewController.modalPresentationStyle = .fullScreen
//        modalViewController.eventImage = eventImage
//        modalViewController.eventTitle = eventTitle
//        modalViewController.eventPlace = eventPlace
        let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
        self.present(modalViewController, animated: false, completion: nil)
    }
    @objc func textFieldDidChange() {
        if placeTextField.text != "" {
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
