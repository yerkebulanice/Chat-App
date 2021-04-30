//
//  LoginViewController.swift
//  Chat App
//
//  Created by Еркебулан on 28.04.2021.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        loginButton.layer.masksToBounds = true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]
            (result, error) in
            if error != nil {
                print("Failed to login in, \(error!)")
            } else {
                self?.performSegue(withIdentifier: "goToChatFromLogin", sender: nil)
            }
        }
    }
}
