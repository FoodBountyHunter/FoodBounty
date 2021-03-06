//
//  ReviewSubmitViewController.swift
//  FoodBounty
//
//  Created by Jason Lehmann on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//                          [String,String  , NSDate?  , NSDate,  , float  , float   ,char[140]
// Assumine Table "Review : [JobID ,HunterID, orderDate, orderTime,qualRate, timeRate, comments]
//
//

import UIKit

class ReviewSubmitViewController: UIViewController ,UITextViewDelegate{
    
    @IBOutlet weak var hunterLabel: UILabel!
    @IBOutlet weak var commentsTextField: UITextView!
    @IBOutlet weak var timelinessLabel: UILabel!
    @IBOutlet weak var timelinessSlider: UISlider!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var qualitySlider: UISlider!
    
    var review: Review!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextField.delegate = self
        
        self.navigationItem.hidesBackButton = true
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        let finishButton = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: self, action: "finish")
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = finishButton
        
        let predicate = NSPredicate(format: "OrderID = testOrderID")
        
        self.hunterLabel.text = review.hunterId.username
        self.timelinessLabel.text = "3"
        self.qualityLabel.text = "3"
        
    }
    
    // Should send to Profile View Controller or the Review List view controller
    func cancel() {
        ViewControllerUtils.returnToLastView(self)
    }
    
    
    //Saves action and sends to Profile
    func finish() {
        review.timeliness = timelinessSlider.value
        review.qualityRate = qualitySlider.value
        review.comments = self.commentsTextField.text
        review.finished = true
        review.saveInBackground()
        
        ViewControllerUtils.returnToLastView(self)
    }
    
    @IBAction func timelinessSlider(sender: UISlider) {
        var newValue = round(timelinessSlider.value)
        self.timelinessLabel.text = "\(Int(newValue))"
        self.timelinessSlider.value = newValue
    }
    
    @IBAction func QualitySlider(sender: UISlider) {
        var newValue = round(qualitySlider.value)
        self.qualityLabel.text = "\(Int(newValue))"
        self.qualitySlider.value = newValue
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var maxtext = 140
        //If the text is larger than the maxtext, the return is false
        return count(textView.text) + (count(text) - range.length) <= maxtext
        
    }
    
    
    
}