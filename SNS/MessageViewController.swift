//
//  MessageViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct Message{
    let message:String
    let profileIcon: UIImage?
    let talker:String
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    let uid = Auth.auth().currentUser!.uid
       
    var Messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "同窓会"
        view.backgroundColor = .darkGray
        view.addSubview(navigation)
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(inputTextView)
        bottomView.addSubview(sendButton)
        inputTextView.addSubview(placeholder)
        navigation.addSubview(groupName)
        navigation.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        inputTextView.delegate = self
        tableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: MessagesTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false
                tableView.addGestureRecognizer(tapGesture)
        let rightSwipe = UISwipeGestureRecognizer(
                    target: self,
                    action: #selector(rightSwipe)
                )
                rightSwipe.direction = .right
                self.view.addGestureRecognizer(rightSwipe)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            placeholder.isHidden = true
            sendButton.setImage(UIImage.resize(image: UIImage(systemName: "paperplane")!.withTintColor(.systemBlue), width: 30), for: .normal)
        }else{
            placeholder.isHidden = false
            sendButton.setImage(UIImage.resize(image: UIImage(systemName: "paperplane")!.withTintColor(.systemGray3), width: 30), for: .normal)
        }
//        var frame = inputTextView.frame
//             frame.size.height = inputTextView.contentSize.height
//             inputTextView.frame = frame
//        var frame2 = bottomView.frame
//             frame2.size.height = inputTextView.contentSize.height
//             bottomView.frame = frame2
    }
    
    @objc func send(){
        if inputTextView.text == "" { return }
        Messages.append(Message(message: inputTextView.text, profileIcon: UIImage.getImageByUrl(url: ""), talker: ""))
        tableView.reloadData()
        inputTextView.text = ""
    }
    
    @objc func rightSwipe(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               UIView.animate(withDuration: 0.3, delay: 0.0, options:.curveEaseIn){
                   self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - keyboardSize.height - self.view.frame.height/12, width:self.view.frame.width, height: self.view.frame.height/10)
               }
           }
       }
    
    @objc func keyboardWillhide(notification: NSNotification) {
               UIView.animate(withDuration: 0.3, delay: 0.0, options:.curveEaseIn){
                   self.bottomView.frame = CGRect(x: 0, y: self.tableView.bottom, width: self.view.frame.width, height: self.view.frame.height/10)
           }
       }
    
    @objc public func dismissKeyboard() {
           view.endEditing(true)
       }
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigation.frame = CGRect(x:0, y: 0, width: view.frame.width, height: view.safeAreaInsets.bottom+view.frame.width/5)
        groupName.frame = CGRect(x: (view.frame.width/2)-(groupName.intrinsicContentSize.width/2), y:(navigation.frame.height/2)+3, width: groupName.intrinsicContentSize.width, height: groupName.intrinsicContentSize.height)
        backButton.frame = CGRect(x: navigation.left+20, y:(navigation.frame.height/2)-(groupName.intrinsicContentSize.height/4)+2, width:backButton.intrinsicContentSize.width, height: 30)
        tableView.frame = CGRect(x: 0, y: navigation.bottom, width: view.frame.width, height: view.frame.height-navigation.frame.height-view.frame.height/10)
        bottomView.frame = CGRect(x: 0, y: tableView.bottom, width: view.frame.width, height: view.frame.height/10)
        inputTextView.frame = CGRect(x: 13, y: 15, width: view.frame.width/1.2, height: 40)
        sendButton.frame = CGRect(x: inputTextView.right+10, y: inputTextView.frame.midY-15, width: 30, height: 30)
        placeholder.frame = CGRect(x: 10, y:(inputTextView.frame.height/2)-(placeholder.intrinsicContentSize.height/2), width: placeholder.intrinsicContentSize.width, height: placeholder.intrinsicContentSize.height)
    }
    
    private let navigation:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        return view
    }()
    
    private let groupName:UILabel = {
       let label = UILabel()
        label.text = "同窓会"
        label.textColor = .white
        return label
    }()
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("グループ一覧", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.configuration?.imagePadding = CGFloat(20)
        button.tintColor = .white
        return button
    }()
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = UIColor.systemGray
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let bottomView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        return view
    }()
    
    private let inputTextView:UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 20
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 5, bottom: 11, right: 0)
        return textView
    }()
    
    private let sendButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage.resize(image: UIImage(systemName: "paperplane")!.withTintColor(.systemGray3), width: 30), for: .normal)
        return button
    }()
    
    private let placeholder:UILabel = {
       let label = UILabel()
        label.text = "Aa"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = Messages[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.identifier, for: indexPath) as?
        MessagesTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .systemGray
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
