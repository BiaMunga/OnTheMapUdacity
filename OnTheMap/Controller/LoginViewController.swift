//
//  ViewController.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 11/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let loginCompleteSegue = "completeLogin"
  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           emailTextField.delegate = self
           passwordTextField.delegate = self
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
            }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("login button clicked")
        OnTheMapClient.postSession(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print(OnTheMapClient.Auth.uniqueKey)
        if success {
                self.performSegue(withIdentifier: self.loginCompleteSegue, sender: self)
                OnTheMapClient.getPublicData { (response, error) in
                print(OnTheMapClient.UserDetails.firstName)
                print(OnTheMapClient.UserDetails.lastName)
            }
        } else {
                self.showLoginFailure(message: "Username or password is incorrect. Please try again.")
            }
    }


        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }
    
    func showLoginFailure(message: String) {
               let alertVC = UIAlertController(title: "Failed to Login", message: message, preferredStyle: .alert)
               alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               show(alertVC, sender: nil)
           }


}
