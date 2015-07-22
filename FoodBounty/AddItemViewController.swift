//
//  AddItemViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var amountPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.amountPicker.delegate = self
        self.amountPicker.dataSource = self
    }
    
    func save() {
        ViewControllerUtils.returnToLastView(self)
        var newBountyViewController = self.navigationController?.visibleViewController as! NewBountyViewController
        var designation = designationTextField.text
        var amount = (amountPicker.selectedRowInComponent(0) + 1)
        newBountyViewController.itemTableViewController.newItem(designation, amount: amount)
    }
    
    func cancel() {
        ViewControllerUtils.returnToLastView(self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row+1)"
    }
}
