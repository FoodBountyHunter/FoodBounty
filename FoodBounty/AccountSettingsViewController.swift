//
//  AccountSettingsViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    
    var statePickerValues:[[String]] = [[]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.postalCodeTextField.delegate = self
        
        statePicker.delegate = self
        statePicker.dataSource = self
        
        statePickerValues[0] = AdressHelper.getAllStates()
        self.loadUserData()
    }
    
    func loadUserData() {
        if let user = PFUser.currentUser() {
            let username = user.username
            let email = user.email
            let street = user.objectForKey("street") as? String
            let postalCode = user.objectForKey("postalCode") as? String
            let city = user.objectForKey("city") as? String
            let state = user.objectForKey("state") as? Int
            
            self.usernameLabel.text = username
            self.emailAdressTextField.text = email
            self.streetTextField.text = street
            self.postalCodeTextField.text = postalCode
            self.cityTextField.text = city
            if state != nil {
                self.statePicker.selectRow(state!, inComponent: 0, animated: false)
            }
        }
    }
    
    
    
    func save() {
        if let user = PFUser.currentUser() {
            var email = self.emailAdressTextField.text
            if ViewControllerUtils.isValidEmail(email) {
                user.email = email
                user.setObject(self.streetTextField.text, forKey: "street")
                user.setObject(self.postalCodeTextField.text, forKey: "postalCode")
                user.setObject(self.cityTextField.text, forKey: "city")
                user.setObject(self.statePicker.selectedRowInComponent(0), forKey: "state")
                user.saveInBackground()
            }
            else {
                var alert = UIAlertController(title: "", message: "Please enter a valid E-Mail adress.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        ViewControllerUtils.returnToLastView(self)
    }
    
    func cancel() {
        ViewControllerUtils.returnToLastView(self)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        
        let range = string.rangeOfCharacterFromSet(invalidCharacters, options: nil, range: Range<String.Index>(start: string.startIndex, end: string.endIndex))
        if (range != nil) {
            return false
        }
        
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return statePickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statePickerValues[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return statePickerValues[component][row]
    }
}
