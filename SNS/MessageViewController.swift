//
//  MessageViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/04.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import MessageInputBar
import FirebaseAuth
import FirebaseFirestore

struct Message{
    let message:String
    let profileIcon: UIImage?
    let talker:String
}

struct Sender:SenderType{
    var senderId: String
    var displayName: String
}

struct message:MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, MessageInputBarDelegate, MessageCellDelegate, UITextViewDelegate{
    
    

    let uid = Auth.auth().currentUser!.uid
       
    lazy var currentUser  = Sender(senderId: uid, displayName: "rio")
    let otherUser = Sender(senderId: "other", displayName: "John")
    var messages = [MessageType]()
    
   
    override func loadView() {
           super.loadView()
           let collectionView = ChatMessagesCollectionView()
           collectionView.collectionDelegate = self
           messagesCollectionView = collectionView
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messageInputBar.becomeFirstResponder()
        view.addSubview(messagesCollectionView)
        view.addSubview(navigation)
        navigation.addSubview(groupName)
        navigation.addSubview(backButton)
        view.addSubview(messageInputBar)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        messageInputBar.backgroundView.backgroundColor = .secondarySystemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.layer.cornerRadius = 10.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane")
        messagesCollectionView.backgroundColor = .darkGray
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textViewDidEndEditing(_ textView: MessageInputBar) {
        print("aaaa")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("高さ",messageInputBar.inputTextView.isFirstResponder)
        if messageInputBar.inputTextView.text == ""{
            view.endEditing(true)
            self.messageInputBar.inputTextView.becomeFirstResponder()
            self.messageInputBar.inputTextView.resignFirstResponder()
        }
        print(messageInputBar.isFocused)
        messageInputBar.removeFromSuperview()
    }
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        view.endEditing(true)
        
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.dismiss(animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.frame = CGRect(x: 0, y: view.frame.height/5, width: view.frame.width, height: view.frame.height-(view.frame.height/5)-(view.frame.height/10))
        navigation.frame = CGRect(x:0, y: 0, width: view.frame.width, height: view.safeAreaInsets.bottom+view.frame.width/5)
        groupName.frame = CGRect(x: (view.frame.width/2)-(groupName.intrinsicContentSize.width/2), y:(navigation.frame.height/2)+3, width: groupName.intrinsicContentSize.width, height: groupName.intrinsicContentSize.height)
        backButton.frame = CGRect(x: navigation.left+20, y:(navigation.frame.height/2)-(groupName.intrinsicContentSize.height/4), width: 30, height: 30)
        messageInputBar.frame = CGRect(x:0, y: view.frame.height-view.frame.height/10, width: view.frame.width, height: view.frame.height/10)
       
    }
    

    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String){
        print(messageInputBar.inputTextView.isFirstResponder)
        messageInputBar.inputTextView.becomeFirstResponder()
        print(messageInputBar.inputTextView.isFirstResponder)
    }
    

    lazy var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter
        }()

    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("inputされたよ")
        
        messages.append(message(sender: currentUser, messageId: String(messages.count), sentDate: Date().addingTimeInterval(-16400), kind: .text(text)))
        Firestore.firestore().collection("chat").addDocument(data: [
            "sender": uid,
            "message": text
        ])
        messageInputBar.inputTextView.text = String()
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
       }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section == 0 {
            return groupName.intrinsicContentSize.height+view.frame.height/20
        }
         return 15
        }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            15
        }
    
    private let navigation:UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
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
    
}

extension MessageViewController {
    
    func closeKeyboard(){
        self.messageInputBar.inputTextView.becomeFirstResponder()
        print("いいね", self.messageInputBar.inputTextView.isFirstResponder)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.messageInputBar.inputTextView.resignFirstResponder()
            self.messagesCollectionView.scrollToLastItem()
        }
       
    }
}

extension MessageViewController: MessagesCollectionViewDelegate {
    func didTap() {
        closeKeyboard()
    }
}

extension MessageViewController {

   
    func didTapBackground(in cell: MessageCollectionViewCell) {
        print("バックグラウンドタップ")
        closeKeyboard()
        closeKeyboard()
        closeKeyboard()
    }

    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("メッセージタップ")
        closeKeyboard()
    }


    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("アバタータップ")
        closeKeyboard()
    }

  
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ上部タップ")
        closeKeyboard()
    }


    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ下部タップ")
        closeKeyboard()
    }
}


protocol MessagesCollectionViewDelegate: AnyObject {
    func didTap()
}

class ChatMessagesCollectionView: MessagesCollectionView {
    weak var collectionDelegate: MessagesCollectionViewDelegate?

    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        super.handleTapGesture(gesture)
        collectionDelegate?.didTap()
    }
}

