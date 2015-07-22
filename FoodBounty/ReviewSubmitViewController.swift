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
import Parse
import ParseUI

class ReviewSubmitViewController: UIViewController ,UITextViewDelegate{
          override func viewDidLoad() {
        super.viewDidLoad()
            CommentTextField.delegate = self
            
            let predicate = NSPredicate(format: "OrderID = testOrderID")
            
            
            
            
                          // Do any additional setup after loading the view.
    }
   // var reviewTemplate: PFObject()

    
    @IBOutlet weak var OrderNumber: UINavigationItem!
    @IBOutlet weak var OrderDayLabel: UILabel!
    @IBOutlet weak var OrderTimeLabel: UILabel!
    @IBOutlet weak var BountyHunterName: UILabel!
    @IBOutlet weak var timelinessSliderVal: UISlider!
    @IBOutlet weak var QualitySlideVal: UISlider!
    
    @IBOutlet weak var CommentTextField: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            var query   = PFQuery(className: "Review")
            //equal Is a placeholder
            query.whereKey("JobID", equalTo:"testOrderIDValue ")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    /*
Should enable


*/
                   self.OrderDayLabel.text =  Optional(objects![0]["orderDate"] as! String)
                   self.OrderTimeLabel.text = Optional(objects![0]["orderTime"] as! String)
                   self.BountyHunterName.text = Optional(objects![0]["HunterID"] as! String)

                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
            
        
        
        })
    }

    
    // Should send to Profile View Controller or the Review List view controller
    @IBAction func CancelReview(sender: UIBarButtonItem) {
        
        //change to Profile View Contorller
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Saves action and sends to Profile
    @IBAction func SubmitReview(sender: UIBarButtonItem) {
        
        var ff: Float = 0.5
        var query = PFQuery()
       // var newRow = objects[0]
        var newRow  = PFObject(className: "Review" );
       /* newRow["BountyHunter"] =
        newRow["Order"] = false
        newRow["Reviewer"] = nil */
        
        newRow["qualRate"] = QualitySlideVal.value % 0.5
       newRow["timeRate"] = timelinessSliderVal.value % 0.5
       newRow["comments"] = CommentTextField.text
      //  newRow["complete"]
       // query.
        newRow.saveInBackgroundWithBlock {( selector: Bool, error : NSError?) -> Void in
        println("Object has been saved")
    }
        dismissViewControllerAnimated(true, completion: nil)

    }

    @IBOutlet weak var timelinessSliderValue: UILabel!
    @IBAction func timelinessSlider(sender: UISlider) {
        
        timelinessSliderValue.text = ( timelinessSliderVal.value % 0.5).description
        
    }
    @IBOutlet weak var QualityLabel: UILabel!
    @IBAction func QualitySlider(sender: UISlider) {
         QualityLabel.text =  (QualitySlideVal.value % 0.5).description
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var maxtext = 140
        //If the text is larger than the maxtext, the return is false
        return count(textView.text) + (count(text) - range.length) <= maxtext
        
    }
    
    
    
}
