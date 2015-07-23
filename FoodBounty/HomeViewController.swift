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
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func postNewBounty(sender: AnyObject) {
        if let user = PFUser.currentUser() {
            // check if user has adress set
            //let username = user.username
            //let email = user.email
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
}