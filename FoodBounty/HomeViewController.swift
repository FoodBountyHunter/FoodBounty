//
//  HomeViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//


import UIKit
import QuartzCore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var accountSettingsBarButton: UIBarButtonItem!
    @IBOutlet weak var claimedContainer: UIView!
    @IBOutlet weak var postedBountyContainerView: UIView!
    @IBOutlet weak var openReviewsButton: UIButton!
    
    var postedBountyTableViewController: BountyListTableViewController!
    var claimedBountyTableViewController: BountyListTableViewController!
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        
        self.postedBountyContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.postedBountyContainerView.layer.borderWidth = 0.8
        self.postedBountyContainerView.layer.cornerRadius = 5
        self.claimedContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.claimedContainer.layer.borderWidth = 0.8
        self.claimedContainer.layer.cornerRadius = 5
        
        openReviewsButton.hidden == true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.postedBountyTableViewController.updateTable()
        self.claimedBountyTableViewController.updateTable()
        
        openReviewsButton.hidden == true
        Review.unfinishedReviewCountAsync(forUser: PFUser.currentUser()!) { (count: Int) -> Void in
            if count > 0 {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.openReviewsButton.titleLabel?.text = "\(count) pending Reviews"
                    self.openReviewsButton.hidden = false
                })                
            }
        }
    }
    
    @IBAction func postNewBounty(sender: AnyObject) {
        if let user = PFUser.currentUser() {
            // check if user has adress set
            let street = user.objectForKey("street") as? String
            let postalCode = user.objectForKey("postalCode") as? String
            let city = user.objectForKey("city") as? String
            let state = user.objectForKey("state") as? Int
            
            if (street != "") && (postalCode != "") && (city != "") && (state != nil) {
                self.performSegueWithIdentifier("postNewBountySegue", sender: self)
            }
            else {
                var alert = UIAlertController(title: "Wait!", message: "You have to set your adress before you can post a bounty.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Go to Settings", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                    self.performSegueWithIdentifier("accountSettingsSegue", sender: self)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func openReviewsAction(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedPostedBountiesSegue" {
            self.postedBountyTableViewController = segue.destinationViewController as! BountyListTableViewController
            self.postedBountyTableViewController.displayType = .Posted
        }
        else  if segue.identifier == "embedClaimedBountiesSegue" {
            self.claimedBountyTableViewController = segue.destinationViewController as! BountyListTableViewController
            self.claimedBountyTableViewController.displayType = .Claimed
        }
    }
}