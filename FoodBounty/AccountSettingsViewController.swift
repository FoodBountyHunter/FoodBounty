//
//  AccountSettingsViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
            user.email = self.emailAdressTextField.text
            user.setObject(self.streetTextField.text, forKey: "street")
            user.setObject(self.postalCodeTextField.text, forKey: "postalCode")
            user.setObject(self.cityTextField.text, forKey: "city")
            user.setObject(self.statePicker.selectedRowInComponent(0), forKey: "state")
            user.saveInBackground()
        }
        
        ViewControllerUtils.returnToLastView(self)
    }
    
    func cancel() {
        ViewControllerUtils.returnToLastView(self)
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
