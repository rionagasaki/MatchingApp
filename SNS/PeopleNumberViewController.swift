//
//  PeopleNumberViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/22.
//

import UIKit

class PeopleNumberViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleTextField.inputView = datePicker
        endtitleTextField.inputView = enddatePicker
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        enddatePicker.addTarget(self, action: #selector(enddateChange), for: .valueChanged)
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(titleTextField)
        view.addSubview(duringLabel)
        view.addSubview(endtitleTextField)
        view.addSubview(nextButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        titleTextField.frame = CGRect(x: (view.frame.width/2)-100, y: mainLabel.bottom+30, width: 200, height: titleTextField.intrinsicContentSize.height)
        duringLabel.frame = CGRect(x: titleTextField.right+20, y: mainLabel.bottom+50, width: duringLabel.intrinsicContentSize.width, height: duringLabel.intrinsicContentSize.height)
        endtitleTextField.frame = CGRect(x: (view.frame.width/2)-100, y: titleTextField.bottom+50, width: 200, height: endtitleTextField.intrinsicContentSize.height)
        nextButton.frame = CGRect(x: (view.frame.width/2)-150, y: endtitleTextField.bottom+60, width: 300, height: 55)
    }
    
    @objc func dateChange(){
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd hh:mm"
            titleTextField.text = "\(formatter.string(from: datePicker.date))"
        if endtitleTextField.text != "" && titleTextField.text != ""{
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
            nextButton.backgroundColor = .systemGray3
            nextButton.setTitleColor(UIColor.black, for: .normal)
        }
        }
    
    @objc func enddateChange(){
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd hh:mm"
            endtitleTextField.text = "\(formatter.string(from: datePicker.date))"
        if endtitleTextField.text != "" && titleTextField.text != ""{
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
            nextButton.backgroundColor = .systemGray3
            nextButton.setTitleColor(UIColor.black, for: .normal)
        }
        }
    
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
    
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
    @objc func nextScreen(){
        let modalViewController = TagSelectViewController()
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
    
    
    private let mainLabel:UILabel = {
        let label = UILabel()
        label.text = "日時を追加してください"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let datePicker: UIDatePicker = {
            let dp = UIDatePicker()
            dp.datePickerMode = .dateAndTime
            dp.preferredDatePickerStyle = .wheels
            return dp
        }()
    
    private let enddatePicker: UIDatePicker = {
            let dp = UIDatePicker()
            dp.datePickerMode = .dateAndTime
            dp.preferredDatePickerStyle = .wheels
            return dp
        }()
    
    private let titleTextField:CustomTextField = {
        let textfield = CustomTextField()
        textfield.placeholder = "開始日時"
        textfield.textAlignment = .center
        return textfield
    }()
    
    private let endtitleTextField:CustomTextField = {
        let textfield = CustomTextField()
        textfield.placeholder = "終了日時"
        textfield.textAlignment = .center
        return textfield
    }()
    
    private let duringLabel:UILabel = {
       let label = UILabel()
        label.text = "から"
        return label
    }()
}
