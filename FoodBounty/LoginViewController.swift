//
//  loginViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        updateLoginButtonState()
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor.purpleColor()
//        self.navigationController?.navigationBar.alpha = 1.0;
//        self.navigationController?.navigationBar.translucent = true;
    }
    
    func updateLoginButtonState() {
        loginButton.enabled = (usernameTextField.text! != "" && passwordTextField.text! != "")
    }
    
    func login() {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            if username != "" && password != "" {
                PFUser.logInWithUsernameInBackground(username, password: password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        // user exists
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("logInViewSegue", sender: self)
                        }
                    }
                    else {
                        // user doesn't exist
                        dispatch_async(dispatch_get_main_queue()) {
                            ViewControllerUtils.displayErrorMessage("Login incorrect", label: self.errorLabel)
                        }
                    }
                }
            }
            else {
                ViewControllerUtils.displayErrorMessage("Incomplete Login", label: self.errorLabel)
            }
        }
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        self.login()
    }
    
    @IBAction func usernameEditingChanged(sender: AnyObject) {
        updateLoginButtonState()
        errorLabel.hidden = true
    }
    
    @IBAction func passwordEditingChanged(sender: AnyObject) {
        updateLoginButtonState()
        errorLabel.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            self.login()
        }
        return true
    }
    
}
