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
    public var message: MessageEntity? {
        didSet {
            if let message = message {
//                let scale = UIScreen.main.scale
//                let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 100.0 * scale, height: 100.0 * scale))
//                let url = URL(string: message.imageUrl)
//                photoImageView.kf.indicatorType = .activity
//                photoImageView.kf.setImage(with: url,
//                                      options: [.processor(resizingProcessor)],
//                                      completionHandler: { [ weak self] image, error, cacheType, imageURL in
//                                          self?.imageView.layer.shadowOpacity = 0.5
//                                      }
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

