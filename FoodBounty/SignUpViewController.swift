//
//  SignUpViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        self.emailTextField.delegate = self
        self.createAccountButton.enabled = false
    }
        
    @IBAction func createAccountButtonAction(sender: AnyObject) {
        self.signUp()
    }
    
    @IBAction func updateData() {
        self.errorLabel.hidden = true
        updateCreateAccountButtonState()
    }
    
    func updateCreateAccountButtonState() {
        self.createAccountButton.enabled = (
            self.usernameTextField.text != "" &&
                self.passwordTextField.text != "" &&
                self.passwordConfirmTextField.text != "" &&
                self.emailTextField.text != "")
    }
    
    func signUp() {
        if let username = self.usernameTextField.text,
            password = self.passwordTextField.text,
            passwordConfirm = self.passwordConfirmTextField.text,
            email = self.emailTextField.text {
            if username != "" && password != "" && passwordConfirm != "" && email != "" {
                if password == passwordConfirm {
                    var user = PFUser()
                    user.username = username
                    user.password = password
                    user.email = email
                    
                    user.signUpInBackgroundWithBlock() {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            var alert = UIAlertController(title: "Congratulations!", message: "You successfully created a FoodBounty account!", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                                self.performSegueWithIdentifier("logInAfterSignUpViewSegue", sender: self)
                            })
                            self.presentViewController(alert, animated: true, completion: nil)
                        } else {
                            ViewControllerUtils.displayErrorMessage(error!.localizedDescription, label: self.errorLabel)
                        }
                    }
                }
                else {
                    ViewControllerUtils.displayErrorMessage("Password confirmation not identical", label: self.errorLabel)
                }
            }
            else {
                ViewControllerUtils.displayErrorMessage("Incomplete Data", label: self.errorLabel)
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
        }
        else if textField == passwordConfirmTextField {
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            self.signUp()
        }
        
        return true
    }
}
