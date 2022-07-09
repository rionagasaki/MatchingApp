//
//  NotificationViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MessageInputBar

struct Chat {
    let title:String
    let message:String?
    let groupIcon: UIImage?
    let notifyNum:Int
    let handler:(()->Void)?
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var AllChat = [Chat]()
    var listener: ListenerRegistration?
    
    func configure(title:String, groupIcon:UIImage){
        AllChat.append(Chat(title:title, message: "こんにちは", groupIcon:groupIcon, notifyNum: 3){
            let modalViewController = MessageViewController()
            modalViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
                transition.duration = 0.25
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(modalViewController, animated: false, completion: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllChat.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = AllChat[indexPath.row]
        model.handler!()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("1-2")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as?
        ChatTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        cell.tintColor = .white
        print(indexPath.row, "index")
        let model = self.AllChat[indexPath.row]
        cell.configure(with: model)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        view.addSubview(chatTableView)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatTableView.backgroundColor = .darkGray
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatTableView.frame = CGRect(x: 0, y: view.frame.size.height/7, width: view.width, height: view.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userRef = Firestore.firestore().collection("user")
        self.listener = userRef.addSnapshotListener(){ (querySnapshot, error) in
            if let error = error {
                print("addSnapshotlistenerエラー\(error)")
                return
            }
            self.AllChat = []
            if querySnapshot?.isEmpty == true { return }
            for document in querySnapshot!.documents{
                let userData = userData(document: document)
                self.configure(title: userData.username ?? "", groupIcon: UIImage().getImageByUrl(url: userData.profileImage ?? ""))
                self.chatTableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    private let chatTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.darkGray
        return tableView
    }()
}

