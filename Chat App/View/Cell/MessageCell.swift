//
//  MessageCell.swift
//  Chat App
//
//  Created by Еркебулан on 30.04.2021.
//

import UIKit
import Firebase
import Kingfisher
class MessageCell: UITableViewCell {
    public static let identifier: String = "MessageCell"
    
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoImageViewHeight: NSLayoutConstraint!
    public var message: MessageEntity? {
        didSet {
            if let message = message {
                if message.imageUrl == "" {
                    photoImageViewHeight.constant = 0
                } else {
                    photoImageViewHeight.constant = 170
                }
                let url = URL(string: message.imageUrl)
                photoImageView.kf.setImage(with: url)
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

