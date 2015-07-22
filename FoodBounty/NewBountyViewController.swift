//
//  NewBountyViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import QuartzCore

class NewBountyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var rewardTextField: UITextField!
    @IBOutlet weak var itemTableViewContainer: UIView!
    var itemTableViewController: ItemTableViewController!
    var bounty = Bounty(className: Bounty.pClass)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.commentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.commentTextView.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.commentTextView.layer.borderWidth = 0.8
        self.commentTextView.layer.cornerRadius = 5
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    func cancel() {
        bounty.delete()
        ViewControllerUtils.returnToLastView(self)
    }

    func save() {
        bounty.category = categoryPicker.selectedRowInComponent(0)
        bounty.comment = commentTextView.text
        bounty.reward = (rewardTextField.text as NSString).floatValue
        bounty.poster = PFUser.currentUser()!
        bounty.status = 0
        
        bounty.save()
        
        ViewControllerUtils.returnToLastView(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemTableViewEmbed" {
            self.itemTableViewController = segue.destinationViewController as! ItemTableViewController
            self.itemTableViewController.bounty = self.bounty
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BountyCategory.categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return BountyCategory.categories[row]
    }
}
