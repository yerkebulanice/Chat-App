//
//  MessageCell.swift
//  Chat App
//
//  Created by Еркебулан on 30.04.2021.
//

import UIKit
import Firebase
class MessageCell: UITableViewCell {
    public static let identifier: String = "MessageCell"
    
    
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    public var message: MessageEntity? {
        didSet {
            if let message = message {
                senderLabel.text = message.sender
                messageLabel.text = message.message
                
                if Auth.auth().currentUser?.email == message.sender {
                    containerView.backgroundColor = .systemTeal
                } else {
                    containerView.backgroundColor = .systemYellow
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }
    
}
