//
//  ReviewSubmitViewController.swift
//  FoodBounty
//
//  Created by Jason Lehmann on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ReviewSubmitViewController: UIViewController {
          override func viewDidLoad() {
        super.viewDidLoad()
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
            
            query.whereKey("OrderID", equalTo:"testOrderIDValue ")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    //  self.OrderNumber.title = objects["OrderID"] as! String?
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

    
    
    @IBAction func CancelReview(sender: UIBarButtonItem) {
        
        //change to Profile View Contorller
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SubmitReview(sender: UIBarButtonItem) {
        
        var ff: Float = 0.5
        var query = PFQuery()
       // var newRow = objects[0]
        var newRow  = PFObject(className: "Review" );
       /* newRow["BountyHunter"] =
        newRow["Order"] = false
        newRow["Reviewer"] = nil */
        
        newRow["QualRat"] = QualitySlideVal.value % 0.5
       newRow["timeRate"] = timelinessSliderVal.value % 0.5
       newRow["comments"] = CommentTextField.text
      //  newRow["complete"]
       // query.
        newRow.saveInBackgroundWithBlock {( selector: Bool, error : NSError?) -> Void in
        println("Object has been saved")
    }
        dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func timelinessSlider(sender: UISlider) {
        
    }
    @IBAction func QualitySlider(sender: UISlider) {
        
    }

}
