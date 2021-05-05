//
//  ChatViewController.swift
//  Chat App
//
//  Created by Еркебулан on 28.04.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    public var imageURL: String?
    private let storage = 
    
    private let messageDB = Database.database().reference().child("Messages")
    private var messages: [MessageEntity] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickPhotoButton.layer.cornerRadius = 4
        pickPhotoButton.layer.masksToBounds = true
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        tableView.addGestureRecognizer(tapOnTableView)
        inputTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MessageCell.identifier, bundle: Bundle(for: MessageCell.self)), forCellReuseIdentifier: MessageCell.identifier)
        fetchMessagesFromFirebase()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendMessagesToFirebase()
    }
    
    @IBAction func pickPhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Failed to sign out")
        }
    }
    
}

//MARK: - UIImage Picker Controller
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            imageView.image = image
            return
        }
        
        guard let imageData = image.pngData() else {
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


// MARK: - Internal Methods
extension ChatViewController {
    private func fetchMessagesFromFirebase() {
        messageDB.observe(.childAdded) { [weak self] (snapshot) in
            if let values = snapshot.value as? [String: String] {
                guard let sender = values["sender"] else { return }
                guard let message = values["message"] else { return }
                
                self?.messages.append(MessageEntity(sender: sender, message: message))
                self?.tableView.reloadData()
                self?.scrollToLastMessage()
            }
        }
    }
    
    private func sendMessagesToFirebase() {
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let message = inputTextField.text else { return }
        
        let messageDict: [String: String] = ["sender": email, "message": message]
        sendButton.isEnabled = false
        inputTextField.text = ""
        messageDB.childByAutoId().setValue(messageDict) { [weak self] (error, reference) in
            if error != nil {
                print("Failed to send message, \(error!)")
            } else {
                self?.sendButton.isEnabled = true
            }
        }
    }
    
    @objc private func tappedOnTableView() {
        inputTextField.endEditing(true)
    }
    
    private func scrollToLastMessage() {
        if messages.count - 1 > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

// MARK: - TextField
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint.constant = 50 + 250
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint.constant = 50
        }
        scrollToLastMessage()
    }
    
}


// MARK: - Table View
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
}
