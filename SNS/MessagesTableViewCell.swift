//
//  MessagesTableViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/08.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    static let identifier = "MessageCell"
    
    var messageText:String? {
        didSet{
            guard let text = messageText else { return }
            let width = estimateFrameForTextView(text: text).width + 20
            messageWidth.constant = width
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageWidth: NSLayoutConstraint!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 18
        messageTextView.backgroundColor = .systemGreen
        messageTextView.textAlignment = .center
        messageTextView.font = .systemFont(ofSize: 16)
        messageTextView.isEditable = false
    }
    
    public func configure(with model:Message){
        messageTextView.text = model.message
        messageText = model.message
        profileImage.image = model.profileIcon
    }
    
    private func estimateFrameForTextView(text:String)-> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string:text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
}
