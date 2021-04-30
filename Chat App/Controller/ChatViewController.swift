//
//  ChatViewController.swift
//  Chat App
//
//  Created by Еркебулан on 28.04.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    private let messageDB = Database.database().reference().child("Messages")
    private var messages: [MessageEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        tableView.addGestureRecognizer(tapOnTableView)
        inputTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        fetchMessagesFromFirebase()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendMessagesToFirebase()
        
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

// MARK: - Internal Methods
extension ChatViewController {
    private func fetchMessagesFromFirebase() {
        messageDB.observe(.childAdded) { [weak self] (snapshot) in
            if let values = snapshot.value as? [String: String] {
                guard let sender = values["sender"] else { return }
                guard let message = values["message"] else { return }
                
                self?.messages.append(MessageEntity(sender: sender, message: message))
                self?.tableView.reloadData()
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
    
    @objc func tappedOnTableView() {
        inputTextField.endEditing(true)
    }
    
}

// MARK: - ajsifjojgda
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint.constant = 50 + 250
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint.constant = 50
        }
    }
    
    
    
}


// MARK: - Table View
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.sender
        cell.detailTextLabel?.text = message.message
        return cell
    }
    
    
}
